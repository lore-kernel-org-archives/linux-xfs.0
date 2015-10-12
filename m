Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02B0E7F58
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 14:49:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAB2D304048
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 12:49:22 -0700 (PDT)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
	[209.85.217.180]) by cuda.sgi.com with ESMTP id
	WPBJrruETjWKXpkC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2015 12:49:19 -0700 (PDT)
Received: by lbwr8 with SMTP id r8so151951390lbw.2
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 12:49:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <561BC61E.6010704@Netapp.com>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-45-git-send-email-andreas.gruenbacher@gmail.com>
	<561BC61E.6010704@Netapp.com>
Date: Mon, 12 Oct 2015 21:49:17 +0200
Message-ID: <CAHc6FU6kp1pR8hRU3g2+A07xfpErMa3bNGJ47Sc4gEJS0U3nJQ@mail.gmail.com>
Subject: Re: [PATCH v10 44/46] nfs: Add richacl support
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Andreas Gruenbacher <andreas.gruenbacher@gmail.com>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>

Anna,

On Mon, Oct 12, 2015 at 4:39 PM, Anna Schumaker
<Anna.Schumaker@netapp.com> wrote:
> I'm not a fan of the "one giant function" approach.  Is there any way to split richacl_from_nfs4_acl() into several smaller functions?

sure, parsing the usr/group identifier could be put in a separate
function, for example.

That function cannot stay as it is right now anyway --- we really need
idmapper to tell us when an identifier string cannot be mapped to a
uid or gid so that we can preserve that identifier.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
