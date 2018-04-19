Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35108 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752725AbeDSUVt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Apr 2018 16:21:49 -0400
Subject: Re: [RFC PATCH] db: Stop core dumping on attr3 if block header is not
 recognized
From: Eric Sandeen <sandeen@sandeen.net>
References: <20180418094935.12495-1-cmaiolino@redhat.com>
 <20180418154435.GQ24738@magnolia>
 <20180419091302.coz4clrmr5ubdku2@odin.usersys.redhat.com>
 <20180419200126.GB24738@magnolia>
 <74cfae6a-71d0-dace-f4f0-64d939acb5e3@sandeen.net>
Message-ID: <30a9acf8-77ad-0eb1-d8e9-87d9324da8d1@sandeen.net>
Date: Thu, 19 Apr 2018 15:21:47 -0500
MIME-Version: 1.0
In-Reply-To: <74cfae6a-71d0-dace-f4f0-64d939acb5e3@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org



On 4/19/18 3:18 PM, Eric Sandeen wrote:
> On 4/19/18 3:01 PM, Darrick J. Wong wrote:
> 
>  
>> I like it better, though on further thought I think I like better the
>> idea of printing the contents of all potential magic numbers:
>>
>> For a block starting with:
>>
>> 0xDE 0xAD 0xBE 0xEF 0xCA 0xFE 0xF0 0x0D 0xBA 0xAD...
>>
>> xfs_db> p
>> Unrecognized attr3 block, attempting to print magic numbers and/or blkinfo:
>> unknown.blockhdr.magic = 0xDEADBEEF
>> unknown.da_blkinfo.magic = 0xBAAD
>> unknown.inode.magic = 0xDEAD
> 
> If we asked for an attr3 type, I don't see the value in printing out structures
> that are unrelated to an attr3, like an inode....?
> 
> The whole problem here is that "attr3" is non-specific, and could be several
> formats.  (bad design decision, IMHO, but bridge, water under, etc).  So I'd
> prefer that we only print structures which might be relevant to the thing(s)
> the user asked for.

or (per Darrick's irc suggestion) maybe we should just bite the bullet and create
proper explicit types for attr3_leaf, _node, and _remote, and if the magic attr3
type fails, just tell the user to try the others manually?

-Eric
