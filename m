Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E4C67FF3
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 15:29:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA0B6AC001
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2013 13:29:35 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iHUCMQ8VNeCErol8 for <xfs@oss.sgi.com>;
	Sun, 17 Feb 2013 13:29:34 -0800 (PST)
Date: Mon, 18 Feb 2013 08:29:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: High %user CPU in XFS
Message-ID: <20130217212932.GZ26694@dastard>
References: <CAEUQcehy1fy5-W-TA--2emBgL3y9JskqRPCZf1ED5JDbPHqKTQ@mail.gmail.com>
	<20130217210408.GH2513@sillage.bis.pasteur.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130217210408.GH2513@sillage.bis.pasteur.fr>
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
To: Tru Huynh <tru@pasteur.fr>
Cc: Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On Sun, Feb 17, 2013 at 10:04:08PM +0100, Tru Huynh wrote:
> On Sun, Feb 17, 2013 at 09:20:46PM +0530, Subranshu Patel wrote:
> >  I created 2 filesystem on my system (RHEL 6.3, kernel 2.6.32) - XFS
> > and EXT4 and mounted them.
> probably:
> https://bugzilla.redhat.com/show_bug.cgi?id=883905

Definitely not. That's an idle condition issue and does not
increase CPU usage at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
