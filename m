Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5N9g7h0020667 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 04:42:07 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34BF1315DD8
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 02:42:33 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jURkN83mBgs3urLW for <xfs@oss.sgi.com>;
	Tue, 23 Jun 2009 02:42:33 -0700 (PDT)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [Acl-devel] Re: acl: Preserving the setuid/setgid/sticky bits
Date: Tue, 23 Jun 2009 11:41:44 +0200
References: <200906171446.08032.agruen@suse.de>
	<20090623053221.GN3648@jenkins.smartcity.com>
In-Reply-To: <20090623053221.GN3648@jenkins.smartcity.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906231141.44790.agruen@suse.de>
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
To: acl-devel@nongnu.org
Cc: Brandon Philips <brandon@ifup.org>, xfs@oss.sgi.com

On Tuesday 23 June 2009 07:32:21 Brandon Philips wrote:
> Will need to put a block around the getfacl mode output in the
> POSIXLY_CORRECT case. Other than that SUID/SGID/sticky restore if the
> comment exists makes sense to me.

Alright, fine by me.

> New patch attached with this fix and a test case that will break with
> the original patch applied.

Thanks, Brandon.

I have committed this to the master branch now, together with a man page 
update.

Cheers,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
