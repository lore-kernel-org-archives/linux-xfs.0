Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 196D67F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 10:55:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2588304067
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 08:55:25 -0700 (PDT)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
	[209.85.217.182]) by cuda.sgi.com with ESMTP id
	1jFsVCRsCi7ZJVC5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Oct 2015 08:55:23 -0700 (PDT)
Received: by lbcao8 with SMTP id ao8so66884393lbc.3
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 08:55:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151026214651.GJ8773@dastard>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-4-git-send-email-agruenba@redhat.com>
	<20151026214651.GJ8773@dastard>
Date: Tue, 27 Oct 2015 16:55:22 +0100
Message-ID: <CAHc6FU7YbdmH+S0HZUg1cL++NM4FXFot=GLBr1_6HPhJSP+dvA@mail.gmail.com>
Subject: Re: [PATCH 3/4] xfs: SGI ACLs: Map uid/gid namespaces
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Mon, Oct 26, 2015 at 10:46 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Oct 24, 2015 at 11:16:08PM +0200, Andreas Gruenbacher wrote:
>> @@ -71,10 +72,10 @@ xfs_acl_from_disk(
>>
>>               switch (acl_e->e_tag) {
>>               case ACL_USER:
>> -                     acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
>> +                     acl_e->e_uid = make_kuid(ns, be32_to_cpu(ace->ae_id));
>
> Please don't replace the xfs wrappers with the horribly named
> generic functions. Pass the namespace to xfs_uid_to_kuid(), and
> modify them, please. That way people who don't deal with namespaces
> every day can tell exactly what format conversion is taking place
> just by reading the code...

We would effectively end up with:

  #define xfs_kuid_to_uid from_kuid
  #define xfs_kgid_to_gid from_kgid
  #define xfs_uid_to_kuid make_kuid
  #define xfs_gid_to_kgid make_kgid

Are you sure you really want that?

> This namespace stuff is awful twisty. The posix layer does a user-ns
> to init-ns conversion and here we do a no-op init-ns to init-ns
> conversion. That needs comments in the code to explain exactly why
> one path needs user-ns conversion and the other doesn't, because I'm
> sure as hell not going to remember why these code paths are
> different in 6 months time.

Okay.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
