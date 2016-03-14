Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 61DB77CAF
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 08:02:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 347A430404E
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 06:02:37 -0700 (PDT)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com
	[209.85.213.54]) by cuda.sgi.com with ESMTP id OsaLfOccj72Ec6Kj
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Mar 2016 06:02:34 -0700 (PDT)
Received: by mail-vk0-f54.google.com with SMTP id e6so206978458vkh.2
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 06:02:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160311142719.GG14808@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-22-git-send-email-agruenba@redhat.com>
	<20160311142719.GG14808@infradead.org>
Date: Mon, 14 Mar 2016 14:02:33 +0100
Message-ID: <CAHc6FU64SzTN23LMzGcPex=jRz_Euwb_CHrW=kX+A5sn8=SFSg@mail.gmail.com>
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

On Fri, Mar 11, 2016 at 3:27 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> +static inline int
>> +ext4_acl_chmod(struct inode *inode, umode_t mode)
>> +{
>> +     if (IS_RICHACL(inode))
>> +             return richacl_chmod(inode, inode->i_mode);
>> +     return posix_acl_chmod(inode, inode->i_mode);
>> +}
>
> Thi isn't ext4-specific and potentially duplicated in every caller.
> Please provide this as a common helper.

This can go in neither fs.h nor posix_acl.h nor richacl.h unless we
turn it into a macro, and I don't think we want to add a new header
file for such extreme trivia.

> Also while we're at it, the mode argument is ignore and the function
> always uses inode->i_mode instead.

Right, thanks.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
