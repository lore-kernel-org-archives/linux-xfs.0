Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F2E87CD5
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 15:17:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E8232304048
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 13:17:24 -0700 (PDT)
Received: from mail.SerNet.de (mail.SerNet.de [193.175.80.2]) by cuda.sgi.com
	with ESMTP id DLZmC7xNeWuQ3fL7 (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Mar 2016 13:17:18 -0700 (PDT)
Date: Tue, 15 Mar 2016 21:17:00 +0100
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Message-ID: <20160315201700.GA22945@sernet.de>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
	<20160315071103.GC19747@infradead.org>
	<20160315154514.GB39038@jra3>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160315154514.GB39038@jra3>
Reply-To: Volker.Lendecke@SerNet.DE
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
To: Cristoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, Jeremy Allison <jra@samba.org>

On Tue, Mar 15, 2016 at 08:45:14AM -0700, Jeremy Allison wrote:
> On Tue, Mar 15, 2016 at 12:11:03AM -0700, Christoph Hellwig wrote:
> > People have long learned that we only have 'alloc' permissions.  Any
> > model that mixes allow and deny ACE is a mistake.
> 
> People can also learn and change though :-). One of the
> biggest complaints people deploying Samba on Linux have is the
> incompatible ACL models.

Just to confirm: I see this a lot in the field. NFSv4 ACLs, while not a
perfect match for NTFS ACLs are a lot closer much more usable to people
who want to serve Windows clients.

Also in the pure linux world there is a lot that you can not express
with just rwx, sgid, sticky bits and friends. If you want the additional
functionality of the richacl bits, I would call it a big mistake to
omit negative aces, if just for the reason not to create yet another
ACLs flavor.

> Whilst I have sympathy with your intense dislike of the
> Windows ACL model, this comes down to the core of "who
> do we serve ?"

The world has enough confusion around ACL semanics, please do not add
more to it by creating your own model of the day.

Volker

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
