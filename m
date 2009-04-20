Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3K314ds022364 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 22:01:04 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F71D1CD1182
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 20:00:59 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id CTTldFx7CWDGn0a0 for
	<xfs@oss.sgi.com>; Sun, 19 Apr 2009 20:00:59 -0700 (PDT)
Message-ID: <49EBE56A.1070906@sandeen.net>
Date: Sun, 19 Apr 2009 22:00:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] put xfs build features into the stats file
References: <1520890652.3597921240196368192.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <1520890652.3597921240196368192.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Nathan Scott wrote:
> Separate file?  That line uses a comma separator ... differs to
> every other line in that stats file, painful for parsers.  And
> no risk of breaking anything if its a separate file.
> 
> cheers.

Hm good point.  Might do; not that big a deal, just wanted to be able to
gracefully skip acl/attr xfstests if the xfs build didn't support it :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
