Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B85FF7F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 17:20:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8AFC304043
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 15:20:11 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FbuoXKbHgv19xY1m for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 15:20:04 -0800 (PST)
Date: Sat, 14 Dec 2013 10:20:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Security issue - storing NTACL's in non-NT-security-namespace
Message-ID: <20131213232000.GA10988@dastard>
References: <52A96211.3050602@tlinx.org> <20131212181315.GB20500@samba2>
	<52AAC7CC.8000802@tlinx.org> <20131213105314.GA2117@infradead.org>
	<52AB7CDC.5040801@tlinx.org> <20131213220848.GG1005@samba2>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213220848.GG1005@samba2>
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
To: Jeremy Allison <jra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Samba Technical <samba-technical@lists.samba.org>, "L.A. Walsh" <samba@tlinx.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Dec 13, 2013 at 02:08:48PM -0800, Jeremy Allison wrote:
> On Fri, Dec 13, 2013 at 01:32:12PM -0800, L.A. Walsh wrote:
> > Now NOTE: if I don't use "explicit action" (-a) in my copy:
> > 
> > Ishtar:law/Documents> /usr/bin/cp testfile.txt testcopy.txt
> > Ishtar:law/Documents> attr -l testcopy.txt
> > Attribute "SGI_ACL_FILE" has a 76 byte value for testcopy.txt
> > 
> > ONLY the root-namespace ACL is save  -- the user and security
> > attributes are striped.
> 
> What is the namespace for SGI_ACL_FILE ?

That's XFS's on-disk name for a posix ACL, which are kept the root
namespace.  It's a file ACL, not a default ACL (which are named
SGI_ACL_DEFAULT), so it was placed there by the user after VFS
allowed it to be created.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
