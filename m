Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACN0U6L169370 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:00:31 -0600
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE0271C3B30E
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 15:01:57 -0800 (PST)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id GnqESzA0ckq6yFfA for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 15:01:57 -0800 (PST)
Subject: Re: xfs_repair of critical volume
Mime-Version: 1.0 (Apple Message framework v1082)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <201011121422.28993@zmi.at>
Date: Fri, 12 Nov 2010 15:01:47 -0800
Message-Id: <BE08758D-20B4-48F1-8BF7-FCD0341D38C2@ucsc.edu>
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<4CCD3CE6.8060407@hardwarefreak.com>
	<864DA9C9-B4A4-4B6B-A901-A457E2B9F5A5@ucsc.edu>
	<201011121422.28993@zmi.at>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com


On Nov 12, 2010, at 5:22 AM, Michael Monnerie wrote:

> On Freitag, 12. November 2010 Eli Morris wrote:
>> The filesystem must be pointing to files that don't exist, or
>> something like that. Is there a way to fix that, to say, remove
>> files that don't exist anymore, sort of command? I thought that
>> xfs_repair would do that, but apparently not in this case.
> =

> The filesystem is not optimized for "I replace part of the disk contents =

> with zeroes" and find that errors. You will have to look in each file if =

> it's contents are still valid, or maybe bogus.
> =

> I find the robustness of XFS amazing: You overwrote 1/5th of the disk =

> with zeroes, and it still works :-)
> =

> Now that you are in this state, I'd recommend you
> a) make a *real* *tape* *backup*
> You learned it the hard way: a disk copy is no backup, at least I hope =

> you learned that lesson
> b) Maybe also copy all your files to another system, or you trust your =

> backup from a) very much
> c) reinitialize the full array. Really recreate every array, 2 b sure =

> all your RAIDs work this time.
> d) copy your data backup - either from the other copy of b), or from the =

> tape backup in a)
> =

> Then you will see a correct view of disk space used and which files are =

> still there. Now you must check every files content, some will have =

> bogus content.
> =

> -- =

> mit freundlichen Gr=FCssen,
> Michael Monnerie, Ing. BSc
> =

> it-management Internet Services: Prot=E9ger
> http://proteger.at [gesprochen: Prot-e-schee]
> Tel: +43 660 / 415 6531
> =

> // ****** Radiointerview zum Thema Spam ******
> // http://www.it-podcast.at/archiv.html#podcast-100716
> // =

> // Haus zu verkaufen: http://zmi.at/langegg/


Hi Michael,

thanks for the advise. =


Let me see if I can give you and everyone else a little more information an=
d clarify this problem somewhat. And if there is nothing practical that can=
 be done, then OK. What I am looking for is the best PRACTICAL outcome here=
 given our resources and if anyone has an idea that might be helpful, that =
would be awesome. I put practical in caps, because that is the rub in all t=
his. We could send X to a data recovery service, but there is no money for =
that. We could do Y, but if it takes a couple of months to accomplish, it m=
ight be better to do Z, even though Z is riskier or deletes some amount of =
data, because it is cheap and only takes one day to do.


This is a small University lab setup. We do not have access to a lot of res=
ources. We do have a partial tape backup of this data, but...

a) The time it takes to back up the full 62 TB is long enough to tape that =
it is not really much of a help. Most days we have hundreds of GBs generate=
d and removed. We back up about 12 TB of the most important files, and ones=
 that don't rapidly change, but our tape backup system just can not keep up=
 with everything. Yes, it would be *fantastic* to have a full tape backup s=
ystem that is practical and has the capacity to deal with everything. Becau=
se we have had so many problems with our storage lately, the backup is some=
what stale, partial, and a little suspect. Still, it is there and I will in=
vestigate what can be recovered from it.

b) I don't have another system to copy the files to. Our disk backup is scr=
ewed up and that is all of our storage. We do have a tape backup, as I ment=
ioned, and while it is theoretically possible to dump to tape, rebuild the =
RAID arrays, then dump back, the practical aspects of this process make thi=
s a so-so option. Realistically, it would take more than a month to accompl=
ish. It is a possibility, but is not a really great option.

c) We are working on making sure everything is working OK. I think the powe=
r output from our UPS might be problematic. We are definitely investigating=
 that, because it could be behind all these crazy problems.

d) Checking every files' content manually is not something that is going to=
 work. It would, literally, take years.

Again, thanks for any advise. I'm not trying to be negative, just realistic=
 in what I have to work with in terms of resources and time. =


Would de-fraging the filesystem remove those zeroed files from the filesyst=
em? Does anyone make a XFS utility program that might help? Maybe an XFS ut=
ility that can be used to remove zeroed files from the filesystem? Or remov=
e files that are stored in that one bad LVM volume?

thanks very much,

Eli


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
