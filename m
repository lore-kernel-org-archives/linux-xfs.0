Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AECCD7CAE
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 17:38:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71611304048
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 15:38:35 -0700 (PDT)
Received: from mail-vk0-f50.google.com (mail-vk0-f50.google.com
	[209.85.213.50]) by cuda.sgi.com with ESMTP id qiCpmcQMkrluv8gu
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Mar 2016 15:38:32 -0700 (PDT)
Received: by mail-vk0-f50.google.com with SMTP id e185so80823619vkb.1
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 15:38:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160315071707.GF19747@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-22-git-send-email-agruenba@redhat.com>
	<20160311142719.GG14808@infradead.org>
	<CAHc6FU4TVKKYr-apCNTuR3aWAHpv7wZJ7ixePfy0Qt2VA49TZQ@mail.gmail.com>
	<20160315071707.GF19747@infradead.org>
Date: Wed, 16 Mar 2016 23:38:32 +0100
Message-ID: <CAHc6FU5f4i_nvwR06Cp7dMJ0AZp2ZuXVrY7cdksLOR3y9P1_rw@mail.gmail.com>
Subject: Re: [PATCH v18 21/22] ext4: Add richacl support
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

On Tue, Mar 15, 2016 at 8:17 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Mar 14, 2016 at 12:08:31AM +0100, Andreas Gruenbacher wrote:
>> The xattr representation is the same on disk and at the xattr syscall
>> layer, and so richacl_from_xattr is used for converting into the
>> in-memory representation in both cases. The error codes are not the
>> same when a user supplies an invalid value via setxattr or NFS and
>> when an invalid xattr is read from disk though. I'll add a parameter
>> to richacl_from_xattr to make this more explicit.
>
> Better add a wrapper instead of a parameter.
>
>>
>> >> +static int
>> >> +__ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
>> >> +{
>> >> +     const int name_index = EXT4_XATTR_INDEX_RICHACL;
>> >> +     umode_t mode = inode->i_mode;
>> >> +     int retval, size;
>> >> +     void *value;
>> >> +
>> >> +     if (richacl_equiv_mode(acl, &mode) == 0) {
>> >> +             inode->i_ctime = ext4_current_time(inode);
>> >> +             inode->i_mode = mode;
>> >> +             ext4_mark_inode_dirty(handle, inode);
>> >> +             return __ext4_remove_richacl(handle, inode);
>> >> +     }
>> >
>> > Should this check for a NULL acl instead of special casing that
>> > in ext4_set_richacl?
>>
>> I'm not sure I understand what you mean. When the
>
> ext4_set_richacl checks for a NULL acl pointer and then calls into
> __ext4_remove_richacl.  I'd rather have that special casing in one
> place.

Those are two different cases: the first is where ext4_set_richacl is
called with a NULL acl to remove an existing ACL; the second is where
ext4_set_richacl is called with a mode-equivalent ACL to set the mode
and remove any existing ACL.

The check for mode-equivalent ACLs is in __ext4_set_richacl and not in
ext4_set_richacl because an inherited ACL (ext4_init_acl) can also be
mode-equivalent.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
