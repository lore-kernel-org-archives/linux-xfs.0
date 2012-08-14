Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7EGxTxX240211 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 11:59:29 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ENrncywpNT98Tp9g
	for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 09:59:28 -0700 (PDT)
Message-ID: <502A83F2.6070805@hardwarefreak.com>
Date: Tue, 14 Aug 2012 11:59:30 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: howto keep xfs directory searches fast for a long time
References: <6344220.LKveJofnHA@saturn> <2561870.uQFC4XLYQm@saturn>
	<20120813235623.GJ2877@dastard> <1888734.iS4pqoU89M@saturn>
In-Reply-To: <1888734.iS4pqoU89M@saturn>
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

On 8/14/2012 4:16 AM, Michael Monnerie wrote:
> Am Dienstag, 14. August 2012, 09:56:23 schrieb Dave Chinner:
>> [locate]
>> Use the right tool for the job....
> 
> That tool just isn't available for people accessing the files - they are 
> (should I say "of course"?) accessing from a box like Windows or with a 
> Media Player, either way nothing that's anywhere near a command line.

All the media players have playlist and index features.  So there's
little need for searching an entire Samba share is there?

Maybe you need to further explain exactly how users interact with these
thousands of media files from Windows/etc clients.

Surely there is a freeware Linux program to index such media files to a
database, and present them in a sorted web interface, or a web interface
that does the 'searching'.

What you apparently require is not something that can be addressed or
optimized by filesystem or kernel tweaks.  As Dave pointed out with the
'locate' example in a CLI, this kind of thing is precisely what
databases were designed for.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
