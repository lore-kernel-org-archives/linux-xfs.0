Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D14C87CA1
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 11:09:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CA9330404E
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 09:09:30 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yRBVRMCA2CtOcwjX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 09:09:28 -0700 (PDT)
Date: Mon, 21 Mar 2016 09:09:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 19/22] richacl: Add richacl xattr handler
Message-ID: <20160321160922.GA18734@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-20-git-send-email-agruenba@redhat.com>
	<20160311141735.GF14808@infradead.org>
	<20160311141905.GC13178@fieldses.org>
	<20160315071014.GB19747@infradead.org>
	<20160315210526.GC3658@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160315210526.GC3658@fieldses.org>
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
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Mar 15, 2016 at 05:05:26PM -0400, J. Bruce Fields wrote:
> > That people get confused between the attr used by the xattr syscall
> > interface and the attr used to store things on disk or the protocol.
> > This has happened every time we have non-native support, e.g. XFS, NFS,
> > CIFS, ntfs, etc.  And it's only going to become worse.
> 
> How has that confusion caused problems in practice?

We had all kinds of bugs in this area that were only slowly uncovered.
We also had all kind of privilegue escalations with (non-ACLs) xattrs
as people never grasped the way different free-form namespaces have
different permission checking.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
