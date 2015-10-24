Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 22D857F59
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 16:05:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9DE4FAC002
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:05:53 -0700 (PDT)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
	[209.85.215.42]) by cuda.sgi.com with ESMTP id CoJrLbBpzVYXBluw
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 24 Oct 2015 14:05:51 -0700 (PDT)
Received: by lfaz124 with SMTP id z124so114248091lfa.1
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 14:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151024152254.GA22232@bfoster.bfoster>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
Date: Sat, 24 Oct 2015 23:05:49 +0200
Message-ID: <CAHc6FU7L15fCusqOONjtB8QQnGVPSW7+KKuENvFxKELmdnqmaA@mail.gmail.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Sat, Oct 24, 2015 at 5:22 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Sat, Oct 24, 2015 at 03:58:04PM +0200, Andreas Gruenbacher wrote:
>> The posix_acl_* attributes are handled by the vfs
>> posix_acl_*_xattr_handler handlers which talk to the filesystem using
>> the get_acl and set_acl inode operations. We would need such handlers
>> for SGI_ACL_*, installed before xfs_xattr_trusted_handler in
>> xfs_xattr_handlers.
>>
>
> Yes, but the translation all occurs on the XFS side. I'm not following
> the last bit... are you suggesting a special xattr handler that uses
> "trusted.SGI_FILE" as a prefix?

Yes.

> I'm not sure that matters either way so
> long as those xattrs are trapped appropriately, but feel free to send a
> patch. :)

I'll send some patches.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
