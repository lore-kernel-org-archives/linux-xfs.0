Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A21E7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 12:41:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E29B304039
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 10:41:55 -0700 (PDT)
Received: from mail-qe0-f53.google.com (mail-qe0-f53.google.com
	[209.85.128.53]) by cuda.sgi.com with ESMTP id OVpkjud1OuP0CK1N
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Sep 2013 10:41:54 -0700 (PDT)
Received: by mail-qe0-f53.google.com with SMTP id jy17so2938801qeb.40
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 10:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130916154423.GA455@infradead.org>
References: <52165830.8050006@redhat.com> <52325369.1070001@sgi.com>
	<20130916154423.GA455@infradead.org>
Date: Mon, 16 Sep 2013 13:41:53 -0400
Message-ID: <CAJzLF9mxFMjLmOPAF0FSxjQYtW41tW54+Siu7vym7JCnt0ABSQ@mail.gmail.com>
Subject: Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
From: "Michael L. Semon" <mlsemon35@gmail.com>
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
Cc: Brian Foster <bfoster@redhat.com>, Mark Tinguely <tinguely@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Sep 16, 2013 at 11:44 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Sep 12, 2013 at 06:51:05PM -0500, Mark Tinguely wrote:
>> The secret to tripping over the bug is run the test until fsstress
>> fills the filesystem before removing the files. So an error
>> handling?
>>
>> I use the test:
>>
>> #!/bin/sh
>>
>> ltp/fsstress -z -s 1378390208 -fsymlink=1 -n9999999 -p4 -d /test2
>> cd /test2
>> sync
>> rm -rf *
>>
>> If your filesystem is smaller, decrease the -n to make the test faster.
>>
>> I have still not gotten a core, though Michael Semon sent one.
>
> It would be useful if we could wire this up for xfstests

Just set it up accurately because it takes a long time.   It takes a
while to create the links.  Additionally, fsstress will keep iterating
after the FS is full, and all those extra iterations take time.

In testing on x86, Brian's test will succeed in 10 GB but fail in 11
GB.  I don't know if that is the case on x86_64 as well.  After the
failure case is met and the rm operation hits the assert, continued
mount-and-rm operations will also cause the assert to fire, without
needing to fill the FS with links again.  I don't know when that
"bonus condition" stops happening.  xfs_repair makes matters
worse, IIRC.

That's about all I can add.  Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
