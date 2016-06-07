Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9DA77CA2
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 04:33:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 99DB38F8037
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 02:33:35 -0700 (PDT)
Received: from mail-qg0-f49.google.com (mail-qg0-f49.google.com
	[209.85.192.49]) by cuda.sgi.com with ESMTP id 8FCHhBaXm0lLGMSw
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Jun 2016 02:33:33 -0700 (PDT)
Received: by mail-qg0-f49.google.com with SMTP id q32so55236149qgq.3
	for <xfs@oss.sgi.com>; Tue, 07 Jun 2016 02:33:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160607062717.GA30022@infradead.org>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Tue, 7 Jun 2016 03:33:32 -0600
Message-ID: <CAAA5faELfZidgODiVfAVDr7AOrGpgfap9rm_UCfLmWh136mb2Q@mail.gmail.com>
Subject: Re: crash in xfs in current
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
Cc: Daniel Wagner <wagi@monom.org>, Eric Sandeen <sandeen@sandeen.net>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Jun 7, 2016 at 12:27 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jun 06, 2016 at 11:39:59PM -0500, Eric Sandeen wrote:
>> xfs_dir2_leaf_lookup_int() only hits that ASSERT if it was given
>> a name to rename, and failed to find the original.  i.e. that should
>> not happen.
>>
>>         /*
>>          * Loop over all the entries with the right hash value
>>          * looking to match the name.
>>          */
>>
>> <do that loop>
>> <fail to find the hash value for the name>
>> <then:>
>>
>>         ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
>>         /*
>>          * Here, we can only be doing a lookup (not a rename or remove).
>>          * If a case-insensitive match was found earlier, re-read the
>>          * appropriate data block if required and return it.
>>          */
>>
>> A rename should never fail to find the original name.
>
> FYI, this looks very much the same like the Bug Daniel reported, which
> I tried to help debugging in person over the weekend.  His backtrace
> points to cancelling a dirty transaction after xfs_dir_replace failed,
> which most likely comes from the failing lookup, except that he probably
> doen't have XFS_DEBUG enabled.

In my case, it looks like that the lookup failed.
First you try to find the xfs_buf, lbp if the pointer to that buffer.
Then you try to find the leaf entry with the same hash value.
Then you look over the entries with the hash value and look if the names match.
Hopefully XFS_CMP_EXACT is returned.
What I do NOT get is why this flag needs to be set: XFS_DA_OP_OKNOENT
I see it being set in xfs_attr_{get, set, remove}, but I am not able
to see that anywhere in the path of this function.
In each of these xfs_attrs I see locks acquired and locked released,
no problem, other than that it's assumed the you obtain the lock.
If the beginning checks during the lock process don't work out you ASSERT.

>
> Given that 4.7-rc1 comes with the new shared locks for lookups, and
> there are very little other changes I wonder if there is any relation
> It would be good if Reinoud and/or Daniel can confirm that Linux 4.6
> is ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
