Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 925A17CA0
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 08:01:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06F96AC001
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:01:45 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id cwHgbRyCvXdtJwQM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 06:01:42 -0800 (PST)
Date: Fri, 11 Mar 2016 06:01:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Message-ID: <20160311140134.GA14808@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Mon, Feb 29, 2016 at 09:17:05AM +0100, Andreas Gruenbacher wrote:
> Al,
> 
> could you please make sure you are happy with the current version of the
> richacl patch queue for the next merge window?

I'm still not happy.

For one I still see no reason to merge this broken ACL model at all.
It provides our actualy Linux users no benefit at all, while breaking
a lot of assumptions, especially by adding allow and deny ACE at the
same sime.

It also doesn't help with the issue that the main thing it's trying
to be compatible with (Windows) actually uses a fundamentally different
identifier to apply the ACLs to - as long as you're still limited
to users and groups and not guids we'll still have that mapping problem
anyway.

But besides that fundamental question on the purpose of it I also
don't think the code is suitable, more in the individual patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
