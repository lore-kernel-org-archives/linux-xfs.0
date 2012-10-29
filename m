Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TCfEjA165044 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 07:41:14 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-cha.cpub.univ-nantes.fr
	[193.52.103.113]) by cuda.sgi.com with ESMTP id
	JHgcOQqNGevtbCPo for <xfs@oss.sgi.com>;
	Mon, 29 Oct 2012 05:43:02 -0700 (PDT)
Message-ID: <508E79D4.5090507@univ-nantes.fr>
Date: Mon, 29 Oct 2012 13:43:00 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Problems with kernel 3.6.x (vm ?) (was : Is kernel 3.6.1 or
	filestreams option toxic ?)
References: <508554AF.5050005@univ-nantes.fr> <50865453.5080708@univ-nantes.fr>
	<508958FF.4000007@univ-nantes.fr> <20121025211047.GD29378@dastard>
	<508A600C.1020109@univ-nantes.fr> <508B092E.6070209@univ-nantes.fr>
	<20121028234802.GE4353@dastard> <20121029012540.GO29378@dastard>
	<20121029121851.GQ29378@dastard>
In-Reply-To: <20121029121851.GQ29378@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Le 29/10/2012 13:18, Dave Chinner a =E9crit :
> On Mon, Oct 29, 2012 at 12:25:40PM +1100, Dave Chinner wrote:
>> On Mon, Oct 29, 2012 at 10:48:02AM +1100, Dave Chinner wrote:
>>> On Sat, Oct 27, 2012 at 12:05:34AM +0200, Yann Dupont wrote:
>>>> Le 26/10/2012 12:03, Yann Dupont a =E9crit :
>>>>> Le 25/10/2012 23:10, Dave Chinner a =E9crit :
>>>> - mkfs.xfs on it, with default options
>>>> - mounted with default options
>>>> - launch something that hammers this volume. I launched compilebench
>>>> 0.6  on it
>>>> - wait some time to fill memory,buffers, and be sure your disks are
>>>> really busy. I waited some minutes after the initial 30 kernel
>>>> unpacking in compilebench
>>>> - hard reset the server (I'm using the Idrac of the server to
>>>> generate a power cycle)
>>>> - After some try, I finally had the impossibility to mount the xfs
>>>> volume, with the error reported in previous mails. So far this is
>>>> normal .
>>> So it doesn't happen every time, and it may be power cycle related.
>>> What is your "local disk"?
>> I can't reproduce this with a similar setup but using KVM (i.e.
>> killing the VM instead of power cycling) or forcing a shutdown of
>> the filesystem without flushing the log. The second case is very
>> much the same as power cycling, but without the potential "power
>> failure caused partial IOs to be written" problem.
>>
>> The only thing I can see in the logprint that I haven't seen so far
>> in my testing is that your log print indicates a checkpoint that
>> wraps the end of the log. I haven't yet hit that situation by
>> chance, so I'll keep trying to see if that's the case that is
>> causing the problem....
> Well, it's taken about 12 hours of random variation of parameters
> in the loop of:
>
> mkfs.xfs -f /dev/vdb
> mount /dev/vdb /mnt/scratch
> ./compilebench -D /mnt/scratch &
> sleep <some period>
> /home/dave/src/xfstests-dev/src/godown /mnt/scratch
> sleep 5
> umount /mnt/scratch
> xfs_logprint -d /dev/vdb
>
> To get a log with a wrapped checkpoint to occur. That was with <some
> period> equal to 36s. In all that time, I hadn't seen a single log
> mount failure, and the moment I get a wrapped log:
>
> 1917 HEADER Cycle 10 tail 9:018456 len  32256 ops 468
> 1981 HEADER Cycle 10 tail 9:018456 len  32256 ops 427
>              ^^^^^^^^^^^^^^^
> [00000 - 02045] Cycle 0x0000000a New Cycle 0x00000009
>
> [  368.364232] XFS (vdb): Mounting Filesystem
> [  369.096144] XFS (vdb): Starting recovery (logdev: internal)
> [  369.126545] XFS (vdb): xlog_recover_process_data: bad clientid 0x2c
> [  369.129522] XFS (vdb): log mount/recovery failed: error 5
> [  369.131884] XFS (vdb): log mount failed
>
> Ok, so no LVM, no power failure involved, etc. Dig deeper. Let's see
> if logprint can dump the transactional record of the log:
>
> # xfs_logprint -f log.img -t
> .....
> LOG REC AT LSN cycle 9 block 20312 (0x9, 0x4f58)
>
> LOG REC AT LSN cycle 9 block 20376 (0x9, 0x4f98)
> xfs_logprint: failed in xfs_do_recovery_pass, error: 12288
> #
>
> Ok, xfs_logprint failed to decode the wrapped transaction at the end
> of the log. I can't see anything obviously wrong with the contents
> of the log off the top of my head (logprint is notoriously buggy),
> but the above command can reproduce the problem (3 out of 3 so far),
> so I should be able to track down the bug from this.
>
> Cheers,
>
> Dave.
OK, very glad to hear you were able to reproduce it.
Good luck, and now let the chase begin :)

Cheers,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
