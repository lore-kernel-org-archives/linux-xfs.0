Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 80C097F86
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 02:50:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 663BB8F8035
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 00:50:14 -0700 (PDT)
Received: from mout.web.de (mout.web.de [212.227.15.3]) by cuda.sgi.com with
	ESMTP id bkcU1QrTGe4bPByt (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 00:50:12 -0700 (PDT)
Message-ID: <55939BA8.1090400@users.sourceforge.net>
Date: Wed, 01 Jul 2015 09:50:00 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
Subject: Re: XFS: Fine-tuning for checks before the function call
	"xfs_qm_dqrele"?
References: <530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5479F823.60900@users.sourceforge.net>
	<20141130230904.GF16151@dastard>
	<558D1833.3080009@users.sourceforge.net>
	<20150629214355.GE7943@dastard>
In-Reply-To: <20150629214355.GE7943@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

> xfs_dqrele_inode() gets called on every inode in the inode cache,
> and this change results in a cacheline in every inode being dirtied
> even if they don't have dquots attached. Given the inode cache can
> hold tens to hundreds of millions of inodes on large machines, we
> don't want to dirty any cachelines we don't need to while walking
> the inode cache and releasing dquots...

Would it make sense to annotate checks before such function calls
as "LIKELY"?

Regards,
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
