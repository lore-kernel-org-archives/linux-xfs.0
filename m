Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 36AD57FC7
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 12:41:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A9F92AC002
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:41:33 -0700 (PDT)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com
	[209.85.215.48]) by cuda.sgi.com with ESMTP id 3EyjRAs3I4GeE03B
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Oct 2015 10:41:31 -0700 (PDT)
Received: by lffv3 with SMTP id v3so83410102lff.0
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:41:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5621346E.5000500@gmail.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
Date: Fri, 16 Oct 2015 19:41:30 +0200
Message-ID: <CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
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
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> I would like to re-iterate, on both XFS and ext4, I _really_ think this
> should be a ro_compat flag, and not an incompat one.  If a person has the
> ability to mount the FS (even if it's a read-only mount), then they by
> definition have read access to the file or partition that the filesystem is
> contained in, which means that any ACL's stored on the filesystem are
> functionally irrelevant,

It is unfortunately not safe to make such a file system accessible to
other users, so the feature is not strictly read-only compatible.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
