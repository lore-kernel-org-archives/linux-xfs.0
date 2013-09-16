Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A6FB7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 12:30:56 -0500 (CDT)
Message-ID: <5237404B.3010309@sgi.com>
Date: Mon, 16 Sep 2013 12:30:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
References: <52165830.8050006@redhat.com> <52325369.1070001@sgi.com>
	<20130916154423.GA455@infradead.org>
In-Reply-To: <20130916154423.GA455@infradead.org>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 09/16/13 10:44, Christoph Hellwig wrote:
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
>

Nod

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
