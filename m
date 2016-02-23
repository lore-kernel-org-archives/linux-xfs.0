Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A66B7F9A
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 13:20:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC09DAC002
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 11:20:03 -0800 (PST)
Received: from mail-vk0-f50.google.com (mail-vk0-f50.google.com
	[209.85.213.50]) by cuda.sgi.com with ESMTP id w0gzeH5p2fm8ABqi
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Feb 2016 11:01:21 -0800 (PST)
Received: by mail-vk0-f50.google.com with SMTP id c3so170546023vkb.3
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 11:01:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHc6FU67LnV7-roofFe1y_uTfvgwonRZimyu7Wn1CDRzwHZJSw@mail.gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F23C.7030902@gmail.com>
	<CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
	<56CA2EEB.9080504@gmail.com>
	<CAHc6FU46vO8NM3cvFH7b8X7U9R+m6wcYj8EQKVnSQkiY3Q051A@mail.gmail.com>
	<56CC3B4A.7070204@gmail.com>
	<CAHc6FU67LnV7-roofFe1y_uTfvgwonRZimyu7Wn1CDRzwHZJSw@mail.gmail.com>
Date: Tue, 23 Feb 2016 20:01:20 +0100
Message-ID: <CAHc6FU4FR577X=sZAPUXhCL4SUfrRYTHw9_byehZqwYyBOhQiA@mail.gmail.com>
Subject: Re: richacl(7) man page review comments
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
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Feb 23, 2016 at 4:09 PM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> Hi Michael,
>
> On Tue, Feb 23, 2016 at 11:58 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> On 02/22/2016 03:46 PM, Andreas Gruenbacher wrote:
>>> On Sun, Feb 21, 2016 at 10:40 PM, Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:
>>>> I've once more pulled from the latest git; here's some more comments.
>>>
>>> thanks again. I've updated the repo with your changes.
>>
>> Next round :-). Just a few quick comments while I'm on a train ride.
>
> applied, thanks.

I've fixed the following additional problems:

> diff --git a/man/richacl.7 b/man/richacl.7
> index acdff31..1c82644 100644
> --- a/man/richacl.7
> +++ b/man/richacl.7
> @@ -30,10 +30,8 @@
>  .SH NAME
>  richacl \- Rich Access Control Lists
>  .SH DESCRIPTION
> -Rich Access Control Lists (RichACLs) are an extension of the POSIX file
> -permission model (see
> -.BR acl (5))
> -to support
> +Rich Access Control Lists (RichACLs) are an extension of the traditional POSIX
> +file permission model to support
>  .URL https://tools.ietf.org/rfc/rfc5661.txt "NFSv4 Access Control Lists"
>  on local and remote-mounted filesystems.

RichACLs are an extension of the traditional POSIX file permission
model, not of the POSIX ACL model.

Unfortunately, there doesn't seem to be a man-page covering POSIX File
Access Permissions as in Appendix A of
http://www.bestbits.at/richacl/draft-gruenbacher-nfsv4-acls-in-posix-00.html.

A lot of the gaps between paragraphs were wrong when rendered for printing.

The modification dates were outdated.

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
