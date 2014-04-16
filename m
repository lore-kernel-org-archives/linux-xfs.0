Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB2D77F50
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 09:14:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B2BEF8F804B
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 07:14:13 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AbeoGsZeqNfc2he8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 07:14:12 -0700 (PDT)
Date: Wed, 16 Apr 2014 07:14:09 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/4] xfs: initialize inode security on tmpfile creation
Message-ID: <20140416141409.GA21743@infradead.org>
References: <1397578706-5385-1-git-send-email-bfoster@redhat.com>
	<1397578706-5385-3-git-send-email-bfoster@redhat.com>
	<20140415175033.GB26404@infradead.org>
	<534D90D0.9090805@tycho.nsa.gov>
	<20140415202222.GA10928@infradead.org>
	<534D94E4.8070606@tycho.nsa.gov> <534E7CDA.2060805@tycho.nsa.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <534E7CDA.2060805@tycho.nsa.gov>
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
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Paul Moore <paul@paul-moore.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>

On Wed, Apr 16, 2014 at 08:51:38AM -0400, Stephen Smalley wrote:
> Maybe I spoke too soon.  IIUC, I_LINKABLE doesn't necessarily
> distinguish tmpfiles from other files, as some tmpfiles may be linkable
> and others not.  But what we want is a way to identify all tmpfiles when
> security_inode_init_security() is called if we are going to label them
> independently of the provided dir.

Oh, right.  If O_EXCL is specified (another annoying overload of the
flag..) the tmpfile can't ever be linked back into the filesystem
and thus doesn't have I_LINKABLE set.

I guess the best way to fix this is using the magic qstr you suggested
before.  That means security_inode_init_security would need to be
called after d_tmpfile, which most filesystems don't do right now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
