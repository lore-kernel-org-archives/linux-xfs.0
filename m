Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6CI9DgQ255988 for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 13:09:13 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49C5535B4BA
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 11:09:50 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0r2t3PKN1YqdnHOK for
	<xfs@oss.sgi.com>; Sun, 12 Jul 2009 11:09:50 -0700 (PDT)
Message-ID: <4A5A26EC.8090503@sandeen.net>
Date: Sun, 12 Jul 2009 13:09:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: bad fs - xfs_repair 3.01 crashes on it
References: <200907031320.48358@zmi.at> <4A4EEBE6.6060909@sandeen.net>
	<200907121902.32599@zmi.at>
In-Reply-To: <200907121902.32599@zmi.at>
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

Michael Monnerie wrote:
> On Samstag 04 Juli 2009 Eric Sandeen wrote:
>> Where's Barry when you need him ....
> 
> Who's that?

The ex-sgi xfs_repair maintainer :)

>> Also I need to look at when the ASSERTs are active and when they
>> should be; the Fedora packaged xfsprogs doesn't have the ASSERT
>> active, and so this doesn't trip.  After 2 calls to xfs_repair on
>> Fedora, w/o the ASSERTs active, it checks clean on the 3rd (!).  Not
>> great.  Not sure how much was cleared out in the process either...
> 
> Any ideas/news on this? I'd like to xfs_repair that stuff. It seems to 
> only hit one file, but I don't dare delete it, maybe it makes things 
> worse?
> 
> mfg zmi

Sorry, I will get back to this soon - today I hope.  I seem to be
getting more and more familiar w/ xfs_repair these days.  :)

If you do want to try deleting that one file or other such tricks, you
can do it on a sparse metadata image of the fs as a dry run:

# xfs_metadump -o /dev/whatever metadump.img
# xfs_mdrestore metadump.img filesystem.img
# mount -o loop filesystem.img mnt/
# <fiddle as you please>
# umount mnt/
# xfs_repair filesystem.img
# mount -o loop filesystem.img mnt/

and see what happens...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
