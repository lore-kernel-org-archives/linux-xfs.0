Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4A6E7F4E
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2014 02:16:30 -0500 (CDT)
Message-ID: <54169248.1090105@sgi.com>
Date: Mon, 15 Sep 2014 09:16:24 +0200
From: Olaf Weber <olaf@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC] Unicode/UTF-8 support for XFS
References: <20140911203735.GA19952@sgi.com> <20140912100230.GB4267@dastard>
	<5412DF37.9030005@sgi.com> <20140912205528.GB11717@infradead.org>
In-Reply-To: <20140912205528.GB11717@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, tinguely@sgi.com, xfs@oss.sgi.com

On 12-09-14 22:55, Christoph Hellwig wrote:
> On Fri, Sep 12, 2014 at 01:55:35PM +0200, Olaf Weber wrote:
>> I looked up those discussions in the archives.  For example, here's
>> Christoph about rejecting filenames if they're not well-formed unicode.
>>     http://marc.info/?l=linux-fsdevel&m=120876935526856&w=2
>> And Jamie Lokier making a similar point:
>>     http://oss.sgi.com/archives/xfs/2008-04/msg01263.html
>
> And I might now disagree with my past self.  While non-ut8 characters
> are perfectly valid unix filenames, and I think everyones life is easier
> if we generally stay out of the utf8 business it seems that for this
> particular use case (shared filesystem with Windows, right) just
> accepting utf8 should be fine.  ZFS is doing, MacOS X apparently is,
> and NFSv4 requires it, although as far as I know most implementations
> ignore that requirement.
>

One issue is working in environments that are not UTF-8 clean.  For example, 
unpacking a tarball with non-UTF-8 filenames in it. The names would have to 
be transcoded, which is only really possible if you know the original 
character set. And if the filesystem flat out rejects non-UTF-8 filenames, 
then you'd be unable to unpack the tarball at all.

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696796
                            Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-6796
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
