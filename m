Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HBYUi7152641 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 05:34:30 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id wZFG1SktBG0GUs5a
	for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 03:34:29 -0800 (PST)
Message-ID: <4F155CC2.3050201@hardwarefreak.com>
Date: Tue, 17 Jan 2012 05:34:26 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Optimal XFS formatting options?
References: <33140169.post@talk.nabble.com> <20120116231121.GB6922@dastard>
	<4F14EBAF.10808@hardwarefreak.com> <201201171019.58714@zmi.at>
In-Reply-To: <201201171019.58714@zmi.at>
Reply-To: stan@hardwarefreak.com
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On 1/17/2012 3:19 AM, Michael Monnerie wrote:
> On Dienstag, 17. Januar 2012 Stan Hoeppner wrote:
>> Thanks for the correction/reminder Dave.  So in this case the first
>> sector of the first partition would need to reside at LBA1280 in this
>> array (655360 byte stripe width, 1280 sectors/stripe), as the
>> partition table itself is going to occupy some sectors at the
>> beginning of the first stripe.  By creating the partition at LBA1280
>> we make sure the first sector of the XFS filesystem is aligned with
>> the first sector of the 2nd stripe.
> 
> There's one big problem with that: Many people will sooner or later 
> expand and existing array. If you add one drive, all your nice stripe 
> width alignment becomes bogus, and suddenly your performance will drop.

So to be clear, your issue with the above isn't with my partition
alignment math WRT the OP's P2000 array, but is with using XFS stripe
alignment in general, correct?

> There's no real way out of that, but three solutions come to my mind:
> - backup before expand/restore after expand with new alignment
> - leave existing data, just change mount options so after expansion at 
> least new files are going to be aligned to the new stripe width. 
> - expand array by factors of two. So if you have 10 data drives, add 10 
> data drives. But that creates other problems (probability of single 
> drive failure + time to recover a single broken disk)

There is one really simple way around this issue you describe: don't add
drives to an existing array.  Simply create another array with new
disks, create a new aligned XFS on the array, and mount the filesystem
in an appropriate location.  There is no 11th Commandment stating one
must have a single massive XFS atop all of one's disks. ;)

There is little to no application software today that can't be
configured to store its data files across multiple directories.  So
there's no need to box oneself into the corner you describe above.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
