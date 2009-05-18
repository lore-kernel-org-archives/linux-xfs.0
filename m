Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4IMYV4n014769 for <xfs@oss.sgi.com>; Mon, 18 May 2009 17:34:32 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63B3E2945A1
	for <xfs@oss.sgi.com>; Mon, 18 May 2009 15:34:40 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id VObxajddIMsLWaiI for <xfs@oss.sgi.com>;
	Mon, 18 May 2009 15:34:40 -0700 (PDT)
Message-ID: <4A11E27B.3010708@sandeen.net>
Date: Mon, 18 May 2009 17:34:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair after reboot refuse repair my filesystem
References: <6efe08af0905130010g5e21f4d1w9efb4ed200b5b152@mail.gmail.com>	<4A0B0A71.5010609@sandeen.net>	<6efe08af0905140150g623d5564i5f5a06b5bf8543a5@mail.gmail.com>	<6efe08af0905150135q317d3b7dy37907332c02510c2@mail.gmail.com>
	<4A0F0325.8000908@sandeen.net>
In-Reply-To: <4A0F0325.8000908@sandeen.net>
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
To: "Vitaly V. Ch" <vitaly.v.ch@gmail.com>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> Is that the first repair of the image?  When I repair it on my box it
> finds many more errors, and does not trip the assert.  I tested 3.0.1 in
> fedora rawhide on x86 this time ...
> 
> -Eric

Oh, well, I'm dumb; the asserts do nothing unless you build with DEBUG
on (as I guess you must have... they are off by default, as they are on
my build) - I'll try to find some time to look into it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
