Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2192F7CCB
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 04:27:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB92D8F8040
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 02:27:02 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id rRIYPWacD2xRGrSA (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2016 02:27:00 -0700 (PDT)
Date: Mon, 8 Aug 2016 11:26:55 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160808092655.GA29128@quack2.suse.cz>
References: <20160727221949.GU16044@dastard>
	<20160728081033.GC4094@quack2.suse.cz>
	<20160729022152.GZ16044@dastard>
	<CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
	<20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
	<20160802002144.GL16044@dastard>
	<1470335997.8908.128.camel@hpe.com>
	<20160805112739.GG16044@dastard>
	<CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CS1PR84MB0119314ACA9B4823C0FE33318E180@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
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
To: "Boylston, Brian" <brian.boylston@hpe.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "Kani, Toshimitsu" <toshi.kani@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Fri 05-08-16 19:58:33, Boylston, Brian wrote:
> Dave Chinner wrote on 2016-08-05:
> > [ cut to just the important points ]
> > On Thu, Aug 04, 2016 at 06:40:42PM +0000, Kani, Toshimitsu wrote:
> >> On Tue, 2016-08-02 at 10:21 +1000, Dave Chinner wrote:
> >>> If I drop the fsync from the
> >>> buffered IO path, bandwidth remains the same but runtime drops to
> >>> 0.55-0.57s, so again the buffered IO write path is faster than DAX
> >>> while doing more work.
> >> =

> >> I do not think the test results are relevant on this point because both
> >> buffered and dax write() paths use uncached copy to avoid clflush. =A0=
The
> >> buffered path uses cached copy to the page cache and then use uncached=
 copy to
> >> PMEM via writeback. =A0Therefore, the buffered IO path also benefits f=
rom using
> >> uncached copy to avoid clflush.
> > =

> > Except that I tested without the writeback path for buffered IO, so
> > there was a direct comparison for single cached copy vs single
> > uncached copy.
> > =

> > The undenial fact is that a write() with a single cached copy with
> > all the overhead of dirty page tracking is /faster/ than a much
> > shorter, simpler IO path that uses an uncached copy. That's what the
> > numbers say....
> > =

> >> Cached copy (req movq) is slightly faster than uncached copy,
> > =

> > Not according to Boaz - he claims that uncached is 20% faster than
> > cached. How about you two get together, do some benchmarking and get
> > your story straight, eh?
> > =

> >> and should be
> >> used for writing to the page cache. =A0For writing to PMEM, however, a=
dditional
> >> clflush can be expensive, and allocating cachelines for PMEM leads to =
evict
> >> application's cachelines.
> > =

> > I keep hearing people tell me why cached copies are slower, but
> > no-one is providing numbers to back up their statements. The only
> > numbers we have are the ones I've published showing cached copies w/
> > full dirty tracking is faster than uncached copy w/o dirty tracking.
> > =

> > Show me the numbers that back up your statements, then I'll listen
> > to you.
> =

> Here are some numbers for a particular scenario, and the code is below.
> =

> Time (in seconds) to copy a 16KiB buffer 1M times to a 4MiB NVDIMM buffer
> (1M total memcpy()s).  For the cached+clflush case, the flushes are done
> every 4MiB (which seems slightly faster than flushing every 16KiB):
> =

>                   NUMA local    NUMA remote
> Cached+clflush      13.5           37.1
> movnt                1.0            1.3 =


Thanks for the test Brian. But looking at the current source of libpmem
this seems to be comparing apples to oranges. Let me explain the details
below:

> In the code below, pmem_persist() does the CLFLUSH(es) on the given range,
> and pmem_memcpy_persist() does non-temporal MOVs with an SFENCE:

Yes. libpmem does what you describe above and the name
pmem_memcpy_persist() is thus currently misleading because it is not
guaranteed to be persistent with the current implementation of DAX in the
kernel.

It is important to know which kernel version and what filesystem have you
used for the test to be able judge the details but generally pmem_persist()
does properly tell the filesystem to flush all metadata associated with the
file, commit open transactions etc. That's the full cost of persistence.

pmem_memcpy_persist() makes sure the data writes have reached persistent
storage but nothing guarantees associated metadata changes have reached
persistent storage as well. To assure that, fsync() (or pmem_persist() if
you wish) is currently the only way from userspace. At which point you've
lost most of the advantages using movnt. Ross researches into possibilities
of allowing more efficient userspace implementation but currently there are
none.

								Honza
-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
