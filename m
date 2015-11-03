Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 558217CBF
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 10:25:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4481A8F8033
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 08:25:49 -0800 (PST)
Received: from mail-oi0-f48.google.com (mail-oi0-f48.google.com
	[209.85.218.48]) by cuda.sgi.com with ESMTP id EbnA4N6TurSdaS1B
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 08:25:46 -0800 (PST)
Received: by oiad129 with SMTP id d129so11703115oia.0
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 08:25:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446563847-14005-46-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-46-git-send-email-agruenba@redhat.com>
Date: Tue, 3 Nov 2015 11:25:46 -0500
Message-ID: <CAHQdGtScoRb-722ES168O8tkp-Rbvwe6bZ=70WwgiXpCC3vsHw@mail.gmail.com>
Subject: Re: [PATCH v13 45/51] sunrpc: Allow to demand-allocate pages to
	encode into
From: Trond Myklebust <trond.myklebust@primarydata.com>
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
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API Mailing List <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Nov 3, 2015 at 10:17 AM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> When encoding large, variable-length objects such as acls into xdr_bufs,
> it is easier to allocate buffer pages on demand rather than precomputing
> the required buffer size.
>

NACK. We're not doing allocations from inside the XDR encoders. This
can and should be done before calling into the SUNRPC layer.

Trond

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
