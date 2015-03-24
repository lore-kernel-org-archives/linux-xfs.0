Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97BD87F37
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 07:43:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 329CFAC003
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:43:55 -0700 (PDT)
Received: from mail-qg0-f53.google.com (mail-qg0-f53.google.com
	[209.85.192.53]) by cuda.sgi.com with ESMTP id Oef9ElKw4KBSfKQo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:43:53 -0700 (PDT)
Received: by qgez102 with SMTP id z102so104598436qge.3
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:43:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150320182621.GH2036@fieldses.org>
References: <20150318185545.GF8818@fieldses.org> <5509E27C.3080004@Netapp.com>
	<20150318205554.GA10716@fieldses.org> <5509E824.6070006@Netapp.com>
	<20150318211144.GB10716@fieldses.org>
	<OFB111A6D8.016B8BD5-ON88257E0D.001D174D-88257E0D.005268D6@us.ibm.com>
	<20150319153627.GA20852@fieldses.org>
	<OF38D4D18B.19055EC2-ON88257E0D.0059BA03-88257E0D.005A781F@us.ibm.com>
	<20150320151718.GD2036@fieldses.org>
	<20150320162303.GA18786@infradead.org>
	<20150320182621.GH2036@fieldses.org>
From: Anna Schumaker <anna.schumaker@netapp.com>
Date: Tue, 24 Mar 2015 08:43:31 -0400
Message-ID: <CAFX2JfkybBPcqD6A8r-jOkPnkL26=NEuK3zhA6TLn-DVam+kfQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Marc Eshel <eshel@us.ibm.com>, linux-nfs-owner@vger.kernel.org, xfs@oss.sgi.com

On Fri, Mar 20, 2015 at 2:26 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Fri, Mar 20, 2015 at 09:23:03AM -0700, Christoph Hellwig wrote:
>> On Fri, Mar 20, 2015 at 11:17:18AM -0400, J. Bruce Fields wrote:
>> > Maybe this is a question for xfs developers.
>> >
>> > So, we have a new READ_PLUS call that's basically just a version of READ
>> > optimized for sparse files:
>> >
>> >     http://tools.ietf.org/html/draft-ietf-nfsv4-minorversion2-33#section-15.10
>> >
>> > It allows an NFS server to return either file data (like a normal READ
>> > call) or, at the server's discretion, records saying "this range of the
>> > data is all zeroes".
>> >
>> > Anna tried implementing READ_PLUS for knfsd using
>> > vfs_llseek(.,.,SEEK_HOLE) followed by an ordinary read if that
>> > determines we're not at a hole.
>> >
>> > (Very) preliminary results suggest that's slower than a plain READ for
>> > an xfs file with no holes.  (And *much* slower in the ext4 case for some
>> > reason.)
>>
>> It should be a fairly cheap operastion, and does extent tree operations
>> that are pretty similar to an (uncached) read.  Do you have profiles?
>>
>> > Is that expected, and should we be doing this some other way instead?
>>
>> Are the read cached or uncached?
>
> I don't know, and don't have profiles.  I'll either try to reproduce or
> wait till Anna's back from vacation.

I'm using whatever functions NFSD already uses for reading files,
which I expect go through the VFS.  Is there a flag that controls
cache behavior?

>
>> If they are from pagecache just copying the zeroes is pretty much
>> unbeatable compared to extent tree lookups, so we'd need a new page
>> flag (difficult..) to see that a page is a hole (and then it would
>> only work for the whole page), but for uncached reads an optimization
>> would be to tell a read that it's an NFS READ_PLUS so that it could
>> just read until it reach a hole, and then we'd need some way to
>> communicate the hole size (or just fall back to SEEK_HOLE for that
>> case).
>
> Ugh, OK.  We'll do some more tests before coming back to ask about
> that....

I only had time for the one run, so I'll do more trials and see if
that one read is always so long.  I'm still hoping it was something in
the way my VM was scheduling its tasks!

Anna

>
> --b.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
