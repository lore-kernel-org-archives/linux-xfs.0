Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5B1Ch2P022802 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 20:12:43 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B22B816EAC26
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 18:12:41 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id vqZAQyatSDCGwIw9
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 18:12:41 -0700 (PDT)
Message-ID: <4DF2C108.70106@hardwarefreak.com>
Date: Fri, 10 Jun 2011 20:12:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Defragging XFS File Systems
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
	<201106090749.37745@zmi.at> <4DF080AC.2090507@hardwarefreak.com>
	<201106091212.36227@zmi.at> <4DF10FDF.1090508@hardwarefreak.com>
	<20110610175656.GW32466@dastard>
In-Reply-To: <20110610175656.GW32466@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Kenneth Emerson <kenneth.emerson@gmail.com>, xfs@oss.sgi.com

On 6/10/2011 12:56 PM, Dave Chinner wrote:
> On Thu, Jun 09, 2011 at 01:24:31PM -0500, Stan Hoeppner wrote:
>> On 6/9/2011 5:12 AM, Michael Monnerie wrote:
>>> On Donnerstag, 9. Juni 2011 Stan Hoeppner wrote:
>>>> When is running xfs_fsr recommended?
>>>
>>> Good question. One case that comes to my mind is a filesystem that was 
>>> used a long time when filled >85%, which has now either been expanded or 
>>> files removed so you have a lot of space again, and you want to defrag 
>>> all those files that have been badly fragmented.
>>>  
>>>> I scheduled it twice a week some time ago due to a filesystem
>>>> containing active mbox files.  I did so because they became so
>>>> heavily fragmented in short order, especially those swallowing
>>>> copious amounts of list mail.  Before cron'ing xfs_fsr I was seeing
>>>> mbox files with over 1000 fragmented extents, and increasing MUA
>>>> latency as the files became more fragmented.  The filesystem is
>>>> currently 90% free.
>>>
>>> This is also an example where defrag may help. You have 10% usage, so 
>>> there's enough space. Maybe your usage fits the mount option 
>>> "allocsize", 
>>
>> I tried allocsize=1m but it didn't seem to help already existing files.
>>  I simply don't think there's much that can be done in filesystem logic
>> to keep long lived constantly appended files from fragmenting, short of
> 
> YOu can stop XFS from truncating speculative preallocation beyond
> EOF by either telling the inode it has preallocated space or
> or turning it into a an append-only file. e.g.
> 
> $ xfs_io -f -c "resvsp 0 4k" <file>
> 
> or
> 
> $ sudo chattr +a <file>
> 
> Either way, XFS won't truncate extents beyond EOF on file close for
> such a file and that should prevent most future fragmentation of the
> file.

Given the way in which individual mails are deleted from an mbox
file[1], how would changing the file to append-only affect a user's
ability to delete mail from that mbox?  Is this something I could use
generically on all mbox files, or is this only applicable to files for
which there is some certainty that they'll only be appended in the future?

[1] http://www.linuxmail.info/mbox-maildir-mail-storage-formats/
1.  Lock the mailbox.
2.  Move the contents of the mailbox, beginning from the position right
    after the mail to be deleted until the end of the mailbox, into the
    position of the mail to be deleted.
3.  Reduce the size of the mailbox file by the size of the deleted mail.
4.  Unlock the mailbox.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
