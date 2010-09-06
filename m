Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o863Licf148651 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 22:21:44 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 228744EA9A
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 20:22:26 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id ggBLnsBYBnnUEboN for
	<xfs@oss.sgi.com>; Sun, 05 Sep 2010 20:22:26 -0700 (PDT)
Message-ID: <4C845E71.20902@sandeen.net>
Date: Sun, 05 Sep 2010 22:22:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS status update for August 2010
References: <20100902145959.GA27887@infradead.org>	<20100905074457.GC16004@1wt.eu>
	<201009051137.07678@zmi.at>
In-Reply-To: <201009051137.07678@zmi.at>
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
Cc: Willy Tarreau <w@1wt.eu>, xfs@oss.sgi.com

Michael Monnerie wrote:
> On Sonntag, 5. September 2010 Willy Tarreau wrote:
>> I've just installed 2.6.35.4
> 
> Try the following mount options: 
> relatime,logbufs=8,logbsize=256k,attr2,barrier,largeio,swalloc,delaylog

relatime is default
logbufs=8 is default
attr2 is default
barrier is default
largeio is not likely anything you want or need
swalloc is unlikely to be useful on a laptop

People need to read up a little and know what they're tuning;
repeating this kind of suggestion leads to cargo-cultism for
performance "tuning"

IOW don't turn knobs just because they are there ... :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
