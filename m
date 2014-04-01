Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A1AD7F53
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 19:19:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A77B304062
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 17:19:15 -0700 (PDT)
Received: from mail-qg0-f50.google.com (mail-qg0-f50.google.com
	[209.85.192.50]) by cuda.sgi.com with ESMTP id YYNYZSifPDJGGq7j
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 31 Mar 2014 17:19:12 -0700 (PDT)
Received: by mail-qg0-f50.google.com with SMTP id q108so8137281qgd.37
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 17:19:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140331145625.GA10791@infradead.org>
References: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
	<20140331145625.GA10791@infradead.org>
Date: Tue, 1 Apr 2014 09:19:12 +0900
Message-ID: <CAKYAXd8adbqepWeDADDtbzk7bTrhXK0CccgewNDsqu0u+HnC4g@mail.gmail.com>
Subject: Re: [PATCH 0/3] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <namjae.jeon@samsung.com>, Jan Kara <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

2014-03-31 23:56 GMT+09:00 Christoph Hellwig <hch@infradead.org>:
> On Mon, Mar 31, 2014 at 11:53:31PM +0900, Namjae Jeon wrote:
>> This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
>> As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
>> in between the file within the range specified by offset and len. User can
>> write new data in this space. e.g. ads.
>> Like collapse range, currently we have the limitation that offset and len
>> should be block size aligned for both XFS and Ext4.
>
> Btw, I remember Samsung also had an ioctl for XFS to split a file into
> two without moving the data, do you plan to submit that one as well?
>
Hi Christoph.
Sure, I'm planning to introduce FS_IOC_MOVE_DATA ioctl that can split
file as well as merging for xfs and ext4.
I already started to implement it. and will post it soon.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
