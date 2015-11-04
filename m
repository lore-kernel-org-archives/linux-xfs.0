Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B1587FC7
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 21:02:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85CD9AC003
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 19:02:34 -0800 (PST)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
	[209.85.215.41]) by cuda.sgi.com with ESMTP id itjukA3SELaXw9tn
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 19:02:28 -0800 (PST)
Received: by lfbf136 with SMTP id f136so34330283lfb.0
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 19:02:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <507E7A63-024B-4EBD-B0C3-4ABE8280440F@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-3-git-send-email-agruenba@redhat.com>
	<507E7A63-024B-4EBD-B0C3-4ABE8280440F@dilger.ca>
Date: Wed, 4 Nov 2015 04:02:27 +0100
Message-ID: <CAHc6FU7q1WOTk_XH+pYOU2=i_ranmtbney9epyFQuTi27qOaGQ@mail.gmail.com>
Subject: Re: [PATCH v13 02/51] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
	permission flags
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

On Wed, Nov 4, 2015 at 3:33 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Nov 3, 2015, at 8:16 AM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
>> @@ -3667,7 +3674,7 @@ EXPORT_SYMBOL(dentry_unhash);
>>
>> int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>> {
>> -     int error = may_delete(dir, dentry, 1);
>> +     int error = may_delete(dir, dentry, true, false);
>
> This is a prime example why passing "true" and "false" as function arguments
> is not very useful, and especially prone to bugs when there are two of them.
>
> That said, this is code originally from Al, so he may have a different
> opinion.

Have you checked how vfs_rename uses the is_dir and new_is_dir
variables? Using file modes there probably won't help readability. An
enum maybe?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
