Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF4917F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 11:52:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68182AC003
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 09:52:47 -0800 (PST)
Received: from mga14.intel.com ([192.55.52.115]) by cuda.sgi.com with ESMTP id
	G5iAywO6neFVpbMP for <xfs@oss.sgi.com>;
	Tue, 17 Nov 2015 09:52:45 -0800 (PST)
Date: Tue, 17 Nov 2015 10:52:43 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 02/11] mm: add pmd_mkclean()
Message-ID: <20151117175243.GA28024@linux.intel.com>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-3-git-send-email-ross.zwisler@linux.intel.com>
	<56468838.6010506@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56468838.6010506@intel.com>
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Nov 13, 2015 at 05:02:48PM -0800, Dave Hansen wrote:
> On 11/13/2015 04:06 PM, Ross Zwisler wrote:
> > +static inline pmd_t pmd_mkclean(pmd_t pmd)
> > +{
> > +	return pmd_clear_flags(pmd, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
> > +}
> 
> pte_mkclean() doesn't clear _PAGE_SOFT_DIRTY.  What the thought behind
> doing it here?

I just wrote it to undo the work done by pmd_mkdirty() - you're right, it
should mirror the work done by pte_mkclean() and not clear _PAGE_SOFT_DIRTY.
I'll fix this for v3, thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
