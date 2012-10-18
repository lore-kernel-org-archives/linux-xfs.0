Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ICDZlu189730 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 07:13:35 -0500
Message-ID: <507FF339.8020208@redhat.com>
Date: Thu, 18 Oct 2012 08:16:57 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-7-git-send-email-bfoster@redhat.com>
	<20121011141335.GY13214@sgi.com> <507749A2.4020206@redhat.com>
	<20121015224626.GU24986@sgi.com>
	<20121015234902.GH2739@dastard> <20121016013901.GI2739@dastard>
	<20121017224004.GG1377@sgi.com>
In-Reply-To: <20121017224004.GG1377@sgi.com>
Content-Type: multipart/mixed; boundary="------------090803030602080205070907"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090803030602080205070907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/17/2012 06:40 PM, Ben Myers wrote:
> Hi Fellas,
> 
> On Tue, Oct 16, 2012 at 12:39:01PM +1100, Dave Chinner wrote:
>> On Tue, Oct 16, 2012 at 10:49:02AM +1100, Dave Chinner wrote:
>>> On Mon, Oct 15, 2012 at 05:46:26PM -0500, Ben Myers wrote:
>>>> Hey Brian,
>>>>
...
>>>> I do think it is preferable to have a test case go in with the code where
>>>> possible.  Since you don't mind waiting a bit, that seems to be the way to go.
>>>> The other option could be to look for a volunteer to work on the test.  ;)
>>>
>>> FWIW, given the background cleanup code can be trivially verified to
>>> work (open, apend, close, repeat, wait 5 minutes) and is the
>>> functionality that is needed in mainline, having something to test
>>> the ioctls should not stop the patchset from being merged.
> 
> Can we be assured that we'll get an xfstest for it eventually?
> 

Absolutely. Getting a command into xfs_io to support such a test is now
the top of my todo list with regard to XFS. :)

> I think we can pull this in if Brian is willing post his test code.  Initially
> it needn't be posted as an xfstest, that's fine.  As it stands today it appears
> that Brian is the only one to ever use the ioctl and there is no way for anyone
> else to test it.  Not an ideal situation.
> 

The impetus for this work was some prototype quota work for the gluster
distributed filesystem. Beyond testing via that, I just had a very
simple/stupid program with the command and data structure bits
copy/pasted in to open a file and invoke an xfsctl() with hardcoded
parameters. I don't consider it post-worthy or very useful, but attached
nonetheless since I have a couple things to deal with before I get a
chance to play with xfs_io.

> I think this is a reasonable request.  Usually it's Christoph who asks for a
> test case.  ;)
> 

Agree.

Brian

>> i.e.:
>>
>> $ for i in `seq 0 512`; do
>>> xfs_io -f -c "pwrite $((i * 4096)) 4096" /mnt/scratch/foo
>>> done
>> $ stat -c %b /mnt/scratch/foo
>> 8192
>> $ sync; stat -c %b /mnt/scratch/foo
>> 8192
>> $ sleep 30; stat -c %b /mnt/scratch/foo
>> 8192
>> $ sleep 300; stat -c %b /mnt/scratch/foo
>> 4104
>>
>> It works. ;)
> 
> Nice!
> 
> Regards,
> Ben
> 


--------------090803030602080205070907
Content-Type: text/x-csrc;
 name="free_eofblocks.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="free_eofblocks.c"

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <xfs/xfs.h>

#include <sys/quota.h>
#ifndef PRJQUOTA
#define PRJQUOTA 2
#endif

/*
 * Speculative preallocation trimming.
 */
#define XFS_EOFBLOCKS_VERSION           1
struct xfs_eofblocks {
        __s32           eof_version;
        __u32           eof_flags;
        __u32           eof_q_id;
        __u32           eof_q_type;
        __u32           eof_min_file_size;
        unsigned char   pad[12];
};

/* eof_flags values */
#define XFS_EOF_FLAGS_SYNC              0x01    /* sync/wait mode scan */
#define XFS_EOF_FLAGS_QUOTA             0x02    /* filter by quota id */
#define XFS_EOF_FLAGS_MINFILESIZE       0x04    /* filter by min file size */

#define XFS_IOC_FREE_EOFBLOCKS  _IOR ('X', 58, struct xfs_eofblocks)

int main(int argc, char *argv[])
{
        int ret, fd;
	struct xfs_eofblocks eofb;

        fd = open(argv[1], O_RDONLY);
	if (fd < 0) {
		perror("open");
		return -1;
	}

	memset(&eofb, 0, sizeof(struct xfs_eofblocks));

	eofb.eof_version = XFS_EOFBLOCKS_VERSION;
	eofb.eof_flags |= XFS_EOF_FLAGS_SYNC;
	//eofb.eof_flags |= XFS_EOF_FLAGS_QUOTA;
	//eofb.eof_q_id = 42;
	//eofb.eof_q_type = PRJQUOTA;
	eofb.eof_flags |= XFS_EOF_FLAGS_MINFILESIZE;
	eofb.eof_min_file_size = 1024 * 1024 * 101;
        ret = xfsctl(NULL, fd, XFS_IOC_FREE_EOFBLOCKS, &eofb);
        if (ret < 0) 
		perror("xfsctl");

        if (close(fd) < 0)
		perror("close");

	return 0;
}


--------------090803030602080205070907
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------090803030602080205070907--
