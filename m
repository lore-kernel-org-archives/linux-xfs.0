Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 974D57CA1
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 07:34:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67B918F8037
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 05:34:34 -0700 (PDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id gB8Oz6CNZmoGfGMp
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2016 05:34:32 -0700 (PDT)
Received: by mail-vk0-f53.google.com with SMTP id w127so4472036vkh.2
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 05:34:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <014101d1d6df$e059fd20$a10df760$@mindspring.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-9-git-send-email-agruenba@redhat.com>
	<1467728537.3800.32.camel@redhat.com>
	<014101d1d6df$e059fd20$a10df760$@mindspring.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 13 Jul 2016 14:34:31 +0200
Message-ID: <CAHc6FU5oeaCxgZPFeNSHDfSjnVKe9km14R4s5RoBhJXPaL7ymQ@mail.gmail.com>
Subject: Re: [PATCH v23 08/22] richacl: Compute maximum file masks from an acl
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
To: Frank Filz <ffilzlnx@mindspring.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@redhat.com>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

Frank,

On Tue, Jul 5, 2016 at 7:08 PM, Frank Filz <ffilzlnx@mindspring.com> wrote:
>> > + * Note: functions like richacl_allowed_to_who(),
>> > +richacl_group_class_allowed(),
>> > + * and richacl_compute_max_masks() iterate through the entire acl in
>> > +reverse
>> > + * order as an optimization.
>> > + *
>> > + * In the standard algorithm, aces are considered in forward order.
>> > +When a
>> > + * process matches an ace, the permissions in the ace are either
>> > +allowed or
>> > + * denied depending on the ace type.  Once a permission has been
>> > +allowed or
>> > + * denied, it is no longer considered in further aces.
>> > + *
>> > + * By iterating through the acl in reverse order, we can compute the
>> > +same
>> > + * result without having to keep track of which permissions have been
>> > +allowed
>> > + * and denied already.
>> > + */
>> >
>>
>> Clever!
>
> Hmm, but does that result in examining the whole ACL for most access checks, at least for files where most of the accesses are by the owner, or a member of a specific group (with perhaps a ton of special case users added on the end)?

I don't understand -- what does this algorithm have to do with access checks?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
