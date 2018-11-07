Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58800 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbeKHFbc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Nov 2018 00:31:32 -0500
Subject: Re: [RFC] xfs: save buffer offset when verifiers fail
References: <f2695097-0728-e525-43a5-d9f183ecba3e@sandeen.net>
 <20181107192900.GB50224@bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b976998f-d1a9-e8d5-e9d2-41ec730fd8e5@sandeen.net>
Date: Wed, 7 Nov 2018 13:59:39 -0600
MIME-Version: 1.0
In-Reply-To: <20181107192900.GB50224@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 11/7/18 1:29 PM, Brian Foster wrote:
> On Wed, Nov 07, 2018 at 11:49:31AM -0600, Eric Sandeen wrote:
>> I'd like to propose an addition to our current metadata verifier error reporting that I believe will allow us to more quickly identify, and more efficiently classify, metadata validation errors when they occur.
...

>> 3) It would allow us to ensure that the hexdump actually contains the
>>    region where the corruption was discovered.
>>
> 
> Yep, though I still think the "first 64 bytes" or whatever of a
> particular buffer is useful to help establish sanity (i.e., is the magic
> sane? is the whole buffer zeroed out? etc.).

Yeah I think we should always print the beginning as well.
 
...

 
> Did we consider some kind of error context structure in the past? I
> don't recall if there were unrelated issues with that, but that seems
> slightly more elegant than an xfs_buf field. Otherwise, the high level
> approach seems reasonable.

Darrick made the same suggestion, and it's a good one thanks.

...

>> We /could/ even go so far as to macrify tests like this, and do:
>>
>>         XFS_VALIDATE_EQ(agf, agf_magicnum, XFS_AGF_MAGIC);
>>         if (!XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)))
>>                 XFS_VERIFIER_FAIL_RETURN(struct xfs_agf, agf_versionnum);
>>         XFS_VALIDATE_EQ(agf, agf_versionnum, XFS_AGF_VERSION);
>>         ...
>>
> 
> This one makes my eyes cross a bit. ;) Though I think it's because now I
> have to wonder a bit about what each macro does. I wouldn't be against
> something like this if we could condense it into something more generic
> and straightforward. For example:
> 
> 	XFS_VERIFY(agf->agf_magicnum == XFS_AGF_MAGIC,
> 		   offsetof(struct xfs_agf, agf_magicnum));
> 	XFS_VERIFY(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)),
> 		   offsetof(struct xfs_agf, agf_versionnum));
> 	...
> 
> I guess you'd need to stick the buffer or whatever stores the bad offset
> value in there somewhere as well, but seeing the explicit logic makes
> this easier to read than following it into a macro. Just my .02.

hah, yeah, that's much better.  Thanks.

-Eric
