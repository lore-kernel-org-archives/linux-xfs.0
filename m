Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C6D2B7F47
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 22:40:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF425304059
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 20:40:45 -0700 (PDT)
Received: from mail-yk0-f171.google.com (mail-yk0-f171.google.com
	[209.85.160.171]) by cuda.sgi.com with ESMTP id
	jeVoSpvM7jfa7Gpd (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 20:40:44 -0700 (PDT)
Received: by mail-yk0-f171.google.com with SMTP id 200so192170ykr.16
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 20:40:44 -0700 (PDT)
In-Reply-To: <20140617152917.GA17378@citd.de>
References: <20140617082651.GA27971@citd.de> <20140617123738.GH9508@dastard>
	<20140617152917.GA17378@citd.de>
MIME-Version: 1.0
Subject: Re: V5 format and man mkfs.xfs
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Tue, 17 Jun 2014 23:39:58 -0400
Message-ID: <83614fca-8984-4ca4-bd3e-d9cbd8a41aad@email.android.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On June 17, 2014 11:29:17 AM EDT, Matthias Schniedermeyer <ms@citd.de> wrote:
>On 17.06.2014 22:37, Dave Chinner wrote:
>> On Tue, Jun 17, 2014 at 10:26:51AM +0200, Matthias Schniedermeyer
>wrote:
>> > Hi
>> > 
>> > How seriously meant is "V5 isn't experimental anymore"?
>> 
>> "Fully supported" isn't a clear enough statement?
>
>I guess that was a "selective memory"-bug on my side.
>
>> > I ask because the man-page only mentions the syntax to enable it by
>
>> > accident. A.k.a. the backport of ftype to V4.
>> > (man-page of xfsprogs 3.2.0 in Debian-SID)
>> 
>> That's intentional. V5 superblocks are an implementation detail that
>> most users don't even need to know about. They care about the name
>> of the features they are enabling at mkfs time, not the details of
>> the on-disk implementation of those features.
>
>The question still stands.
>
>The crc-option is only mentioned "by accident".
>Without the ftype backport there would be no mention of the "feature 
>crc".
>
>Furthermore i suspect that the ftype-feature also wouldn't be
>mentionted 
>without the V4 backport.
>
>Which beggs the question, what other features are "burried" in V5 that 
>aren't mentioned in the man-page.
>
>And are there any other "-m" options, because "-m" (asside from the 
>ftype accident) is completly undocumented.
>
>> > And you still have to know that crc means V5.
>> 
>> Why do you care about the format mkfs.xfs chooses for you - it's
>> based on the features you requested. V5 isn't magically faster than
>
>I find the crc feature relativly important.
>
>I personally had exprienced an USB enclosure(-model. As in i had
>several 
>of those) that under rare circumstances flipped or cleared a single bit
>
>in a specific bit-pattern). Such corruption most likely ends up inside
>a 
>data-file because most times there is more data than meta-data. But 
>COULD happend inside the meta-data.
>
>Since that day i have nearly everything MD5(or SHA256)ed so i can at 
>least detect if i have a data-corruption.
>
>Fortunatly that never happend again after i replaced that enclosure 
>model. Which i can say with pretty high confidence.

I md5 hash a lot of important files.  I've seen lots of failures to verify over the years.  As you note, it is typically a hardware failure, but they happen none the less.

Recently the most common failure has been the sata cables.  They are not very robust if you connect/disconnect them very often.

Greg
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
