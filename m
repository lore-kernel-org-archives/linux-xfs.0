Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7F997CD1
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 10:46:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A2068F8049
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 08:46:19 -0700 (PDT)
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148]) by cuda.sgi.com
	with ESMTP id LMwx9jnT4WGSw0pQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 08:46:17 -0700 (PDT)
Date: Tue, 15 Mar 2016 08:45:14 -0700
From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Message-ID: <20160315154514.GB39038@jra3>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
	<20160315071103.GC19747@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160315071103.GC19747@infradead.org>
Reply-To: Jeremy Allison <jra@samba.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Mar 15, 2016 at 12:11:03AM -0700, Christoph Hellwig wrote:
> On Fri, Mar 11, 2016 at 05:11:51PM +0100, Andreas Gruenbacher wrote:
> > > while breaking a lot of assumptions,
> > 
> > The model is designed specifically to be compliant with the POSIX
> > permission model. What assumptions are you talking about?
> 
> People have long learned that we only have 'alloc' permissions.  Any
> model that mixes allow and deny ACE is a mistake.

People can also learn and change though :-). One of the
biggest complaints people deploying Samba on Linux have is the
incompatible ACL models.

Whilst I have sympathy with your intense dislike of the
Windows ACL model, this comes down to the core of "who
do we serve ?" IMHO we should serve the users (although
I must confess I'd look awful in a TRON suit :-).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
