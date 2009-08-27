Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R9ewK6078028 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 04:41:09 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48FFE40231F
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 02:41:15 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id e4XW0E7UKjIPDMTf for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 02:41:15 -0700 (PDT)
Date: Thu, 27 Aug 2009 02:41:10 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: xfs data loss
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
Message-ID: <alpine.DEB.2.01.0908270232540.5744@bogon.housecafe.de>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
MIME-Version: 1.0
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
To: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, 27 Aug 2009 at 09:22, Passerone, Daniele wrote:
> We have a SUN X4500 with 48 500 GB drives, that we configured under SUSE 
> SLES 10.                                                                                                              

SLES 10, that's Linux 2.6.16-something, right?

> These units are not backed up.

I know, I probably shouldn't ask this right now, but I'm kinda curious: 
_Why_ aren't they backed up?

> 3) xfs_ncheck eats a lot of memory and freezes after 6-7 hours without giving output

Did you look into the syslog too? Maybe the box was out of memory and 
killed xfs_ncheck. How much memory does the box have?

Christian.
-- 
BOFH excuse #101:

Collapsed Backbone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
