Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C39D29DF8
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 02:14:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4959D8F8049
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 00:14:10 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id W7NEWGHWoOMlh5Lr (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 00:14:08 -0800 (PST)
Date: Thu, 12 Dec 2013 00:13:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] nfsd: revoking of suid/sgid bits after chown() in a
	consistent way
Message-ID: <20131212081359.GB2325@infradead.org>
References: <20131206204747.GB12613@fieldses.org>
	<1386756996-28083-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<52A845C6.2080109@oracle.com> <20131212033859.GA5978@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212033859.GA5978@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, vasily.isaenko@oracle.com, xfs@oss.sgi.com, hch@infradead.org, sprabhu@redhat.com, Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

On Wed, Dec 11, 2013 at 10:38:59PM -0500, J. Bruce Fields wrote:
> In the v3 case I'd expect the open O_TRUNC to result in a SETATTR rpc,
> in the v4 case an OPEN rpc.  Both result in a call to nfsd_setattr,
> though I only see nfsd_setattr turning off the SUID/SGID bits in the
> chown case.  Are you sure it isn't the subsequent write that clears
> those bits?

We've traditionally cleared the suid bits for O_TRUNC for local
filesystem, although this is more a convention than a real security
need.  It would still be good if NFSv4 would follow the general
semantics.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
