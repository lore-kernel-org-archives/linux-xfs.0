Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 426F17CB8
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 14:58:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B974CAC008
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 12:58:43 -0700 (PDT)
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
	(mail-bl2nam02on0101.outbound.protection.outlook.com
	[104.47.38.101]) by cuda.sgi.com with ESMTP id 1vmJdvrX4H44uB1l
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 05 Aug 2016 12:58:37 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: Subtle races between DAX mmap fault and write path
Date: Fri, 5 Aug 2016 19:58:33 +0000
Message-ID: <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <20160727120745.GI6860@quack2.suse.cz>
	<20160727211039.GA20278@linux.intel.com>
	<20160727221949.GU16044@dastard>
	<20160728081033.GC4094@quack2.suse.cz> <20160729022152.GZ16044@dastard>
	<CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
	<20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
	<20160802002144.GL16044@dastard> <1470335997.8908.128.camel@hpe.com>
	<20160805112739.GG16044@dastard>
In-Reply-To: <20160805112739.GG16044@dastard>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>

Dave Chinner wrote on 2016-08-05:
> [ cut to just the important points ]
> On Thu, Aug 04, 2016 at 06:40:42PM +0000, Kani, Toshimitsu wrote:
>> On Tue, 2016-08-02 at 10:21 +1000, Dave Chinner wrote:
>>> If I drop the fsync from the
>>> buffered IO path, bandwidth remains the same but runtime drops to
>>> 0.55-0.57s, so again the buffered IO write path is faster than DAX
>>> while doing more work.
>> =

>> I do not think the test results are relevant on this point because both
>> buffered and dax write() paths use uncached copy to avoid clflush. =A0The
>> buffered path uses cached copy to the page cache and then use uncached c=
opy to
>> PMEM via writeback. =A0Therefore, the buffered IO path also benefits fro=
m using
>> uncached copy to avoid clflush.
> =

> Except that I tested without the writeback path for buffered IO, so
> there was a direct comparison for single cached copy vs single
> uncached copy.
> =

> The undenial fact is that a write() with a single cached copy with
> all the overhead of dirty page tracking is /faster/ than a much
> shorter, simpler IO path that uses an uncached copy. That's what the
> numbers say....
> =

>> Cached copy (req movq) is slightly faster than uncached copy,
> =

> Not according to Boaz - he claims that uncached is 20% faster than
> cached. How about you two get together, do some benchmarking and get
> your story straight, eh?
> =

>> and should be
>> used for writing to the page cache. =A0For writing to PMEM, however, add=
itional
>> clflush can be expensive, and allocating cachelines for PMEM leads to ev=
ict
>> application's cachelines.
> =

> I keep hearing people tell me why cached copies are slower, but
> no-one is providing numbers to back up their statements. The only
> numbers we have are the ones I've published showing cached copies w/
> full dirty tracking is faster than uncached copy w/o dirty tracking.
> =

> Show me the numbers that back up your statements, then I'll listen
> to you.

Here are some numbers for a particular scenario, and the code is below.

Time (in seconds) to copy a 16KiB buffer 1M times to a 4MiB NVDIMM buffer
(1M total memcpy()s).  For the cached+clflush case, the flushes are done
every 4MiB (which seems slightly faster than flushing every 16KiB):

                  NUMA local    NUMA remote
Cached+clflush      13.5           37.1
movnt                1.0            1.3 =


In the code below, pmem_persist() does the CLFLUSH(es) on the given range,
and pmem_memcpy_persist() does non-temporal MOVs with an SFENCE:

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <libpmem.h>

/*
 * gcc -Wall -O2 -m64 -mcx16 -o memcpyperf memcpyperf.c -lpmem
 *
 * Not sure if -mcx16 allows gcc to use faster memcpy bits?
 */

/*
 * our source buffer.  we'll copy this much at a time.
 * align it so that memcpy() doesn't have to do anything funny.
 */
char   __attribute__((aligned(0x100))) src[4 * 4096];

int
main(
        int   argc,
        char* argv[]
)
{
        char*    path;
        char     mode;
        int      nloops;
        char*    dstbase;
        size_t   dstsz;
        int      ispmem;
        int      cpysz;
        char*    dst;

        if (argc !=3D 4) {
                fprintf(stderr, "ERROR: usage: "
                        "memcpyperf [cached | nt] PATH NLOOPS\n");
                exit(1);
        }
        mode   =3D argv[1][0];
        path   =3D argv[2];
        nloops =3D atoi(argv[3]);

        dstbase =3D pmem_map_file(path, 0, 0, 0, &dstsz, &ispmem);
        if (NULL =3D=3D dstbase) {
                perror(path);
                exit(1);
        }

        if (!ispmem)
                fprintf(stderr, "WARNING: %s is not pmem\n", path);

        if (dstsz < sizeof(src))
                cpysz =3D dstsz;
        else
                cpysz =3D sizeof(src);

        fprintf(stderr, "INFO: dst %p src %p dstsz %ld cpysz %d\n",
                dstbase, src, dstsz, cpysz);

        dst =3D dstbase;
        while (nloops--) {
                if (mode =3D=3D 'c') {
                        memcpy(dst, src, cpysz);
                        /*
                         * we could do the clflush here on the 16KiB we just
                         * wrote, but with a 4MiB file (dst buffer) and 16K=
iB
                         * src buffer, it seems slightly faster to flush the
                         * entire 4MiB below
                         */
                        //pmem_persist(dst, cpysz);
                }
                else {
                        pmem_memcpy_persist(dst, src, cpysz);
                }
                dst +=3D cpysz;
                if ((dst + cpysz) - dstbase > dstsz) {
                        dst =3D dstbase;
                        /* see note above */
                        if (mode =3D=3D 'c')
                                pmem_persist(dst, dstsz);
                }
        }

        exit(0);

}  /* main() */
EOF

Sample runs:

$ numactl -N0 time -p ./memcpyperf c /pmem0/brian/cpt 1000000
INFO: dst 0x7f3f1a000000 src 0x601200 dstsz 4194304 cpysz 16384
real 13.53
user 13.53
sys 0.00
$ numactl -N0 time -p ./memcpyperf n /pmem0/brian/cpt 1000000
INFO: dst 0x7f2b54600000 src 0x601200 dstsz 4194304 cpysz 16384
real 1.04
user 1.04
sys 0.00
$ numactl -N1 time -p ./memcpyperf c /pmem0/brian/cpt 1000000
INFO: dst 0x7f8f8c200000 src 0x601200 dstsz 4194304 cpysz 16384
real 37.13
user 37.15
sys 0.00
$ numactl -N1 time -p ./memcpyperf n /pmem0/brian/cpt 1000000
INFO: dst 0x7f77f7400000 src 0x601200 dstsz 4194304 cpysz 16384
real 1.24
user 1.24
sys 0.00


Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
