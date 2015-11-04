Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D49007F4E
	for <xfs@oss.sgi.com>; Wed,  4 Nov 2015 16:10:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5924304053
	for <xfs@oss.sgi.com>; Wed,  4 Nov 2015 14:10:46 -0800 (PST)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
	[209.85.217.176]) by cuda.sgi.com with ESMTP id
	n3QNOlM8hbHG6GKV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Nov 2015 14:10:44 -0800 (PST)
Received: by lbblt2 with SMTP id lt2so3726551lbb.3
	for <xfs@oss.sgi.com>; Wed, 04 Nov 2015 14:10:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <713E53A4-D073-4745-B57D-77AD07E89957@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-13-git-send-email-agruenba@redhat.com>
	<713E53A4-D073-4745-B57D-77AD07E89957@dilger.ca>
Date: Wed, 4 Nov 2015 23:10:43 +0100
Message-ID: <CAHc6FU7+UpYGA991zPLyzG2L5pDgkD93L7BXak-TDJT_E_E2YA@mail.gmail.com>
Subject: Re: [PATCH v13 12/51] vfs: Cache richacl in struct inode
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

Andreas,

On Wed, Nov 4, 2015 at 3:03 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>> @@ -33,7 +33,7 @@ richacl_alloc(int count, gfp_t gfp)
>>       struct richacl *acl = kzalloc(size, gfp);
>>
>>       if (acl) {
>> -             atomic_set(&acl->a_refcount, 1);
>> +             atomic_set(&acl->a_base.ba_refcount, 1);
>>               acl->a_count = count;
>>       }
>>       return acl;
>> @@ -52,7 +52,7 @@ richacl_clone(const struct richacl *acl, gfp_t gfp)
>>
>>       if (dup) {
>>               memcpy(dup, acl, size);
>> -             atomic_set(&dup->a_refcount, 1);
>> +             atomic_set(&dup->a_base.ba_refcount, 1);
>
> These two calls should be base_acl_init().

Yes. This should all be fixed in the next snapshot.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
