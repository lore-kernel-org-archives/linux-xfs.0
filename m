Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C90947CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 11:29:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BFD80304043
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 09:29:06 -0800 (PST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id X28wbBHYIMXBJw4R
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Nov 2015 09:29:01 -0800 (PST)
Received: by wmww144 with SMTP id w144so129474690wmw.0
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 09:29:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151116140526.GA6733@quack.suse.cz>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-4-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4j4arHE+iAALn1WPDzSb_QSCDy8udtXU1FV=kYSZDfv8A@mail.gmail.com>
	<22E0F870-C1FB-431E-BF6C-B395A09A2B0D@dilger.ca>
	<CAPcyv4jwx3VzyRugcpH7KCOKM64kJ4Bq4wgY=iNJMvLTHrBv-Q@mail.gmail.com>
	<20151116133714.GB3443@quack.suse.cz>
	<20151116140526.GA6733@quack.suse.cz>
Date: Mon, 16 Nov 2015 09:28:59 -0800
Message-ID: <CAPcyv4jZjnkz2YYtGWmkA23KAUMT092kjRtFkJ3QrzgPfTucfA@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] pmem: enable REQ_FUA/REQ_FLUSH handling
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, Linux MM <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Mon, Nov 16, 2015 at 6:05 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 16-11-15 14:37:14, Jan Kara wrote:
[..]
> But a question: Won't it be better to do sfence + pcommit only in response
> to REQ_FLUSH request and don't do it after each write? I'm not sure how
> expensive these instructions are but in theory it could be a performance
> win, couldn't it? For filesystems this is enough wrt persistency
> guarantees...

We would need to gather the performance data...  The expectation is
that the cache flushing is more expensive than the sfence + pcommit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
