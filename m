Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B515E7F63
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 15:20:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26337AC002
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 13:20:47 -0700 (PDT)
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com
	[209.85.217.174]) by cuda.sgi.com with ESMTP id
	t4QO0ku10sUIRvYO (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 13:20:45 -0700 (PDT)
Received: by lbcao8 with SMTP id ao8so155021451lbc.3
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 13:20:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56253A35.4070309@gmail.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<5624ED40.7040206@gmail.com>
	<CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
	<5625182C.3050007@gmail.com>
	<CAHc6FU75GXGeav1ho-QraPS_F8fpOXnoDyv17+b=koiF=9YE5A@mail.gmail.com>
	<56253A35.4070309@gmail.com>
Date: Mon, 19 Oct 2015 22:20:43 +0200
Message-ID: <CAHc6FU4jcatmY+A39oQb-2x9Gs8WFVsXOD_9eBV=_fgNzZx3Xg@mail.gmail.com>
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

On Mon, Oct 19, 2015 at 8:45 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-10-19 13:33, Andreas Gruenbacher wrote:
>> Please spare me with all that nonsense. Compared to mount options,
>> filesystem feature flags in this case simplify things (you don't have
>> to specify whether a filesystem contains POSIX ACLs or richacls), and
>> they prevent administrator errors: when a filesystem mounts, it is
>> safe to use; when it doesn't, it is not. That's all there is to it.
>
> You're ignoring what I'm actually saying. I've said absolutely nothing
> about needing to use mount options at all, and I'm not arguing against using
> filesystem feature flags, I'm arguing for using them sensibly in a way that
> does not present a false sense of security.

We could be on a multi-user system, and the user mounting the
filesystem may not be the only user on the system. When a filesystem
can be mounted read-only, it should be safe to use read-only. It is
not safe in general to use such a filesystem read-only, so an
incompatible feature flag which prevents such unsafe mounting is more
approporiate than a read-only incompatible feature flag.

Mounting a filesystem read-only doesn't mean that the filesystem is
being recovered, it is perfectly legal to mount a filesystem read-only
for other reasons. I don't want to give people using read-only
filesystems the false sense that everything is okay.

> Making it an incompatible flag will likely cause headaches for some
> legitimate users,

Indeed. It will also make it less likely for users to accidentally
shoot themselves in the foot. If someone knows better, they can clear
the feature flag.

When recovering a broken system that contains richacl filesystems, you
really want to have richacl support in the rescue system as well.
Otherwise, you won't be able to fsck those filesystems.

> and at most delay competent hackers by a few seconds to a
> few minutes, and script kiddies by a few hours, and is really no better than
> security by obscurity (and from a purely logistical standpoint, that's _all_
> it is) in that it actively tries to hide the fact that someone having read
> access to the storage the filesystem is on can bypass the ACL's.
>
> To reiterate, if someone can call mount() on a filesystem, and mount() does
> not return -EPERM, then even if mount() returns a different error, they
> still have the ability to completely bypass all permissions and ACL's in
> that filesystem, because they have the ability to read the entire filesystem
> directly.
>
> The _only_ way to properly protect against people bypassing the ACL's is to
> use full disk encryption and lock down root access on the system, and even
> that can't completely prevent it from happening.

That's all completely beside the point. I'm not talking about
preventing attacks at all, just basic administrative workflows.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
