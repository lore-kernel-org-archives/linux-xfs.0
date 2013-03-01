Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA3257FAF
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 03:37:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4604BAC004
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 01:37:40 -0800 (PST)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	QUDqseexcAxgFqPT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 01:37:38 -0800 (PST)
Received: by mail-wi0-f174.google.com with SMTP id hi8so8824102wib.1
	for <xfs@oss.sgi.com>; Fri, 01 Mar 2013 01:37:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512FA67D.2090708@sandeen.net>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<512FA67D.2090708@sandeen.net>
From: Ole Tange <tange@binf.ku.dk>
Date: Fri, 1 Mar 2013 10:37:17 +0100
Message-ID: <CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
Subject: Re: xfs_repair segfaults
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Feb 28, 2013 at 7:48 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/28/13 9:22 AM, Ole Tange wrote:

>> /usr/local/src/xfsprogs-3.1.10/repair# ./xfs_repair -n /dev/md5p1
[...]
>> Segmentation fault (core dumped)
>>
>> Core put in: http://dna.ku.dk/~tange/tmp/xfs_repair.core.bz2
>
> We'd need a binary w/ debug symbols to go along with it.

http://dna.ku.dk/~tange/tmp/xfs_repair

> an xfs_metadump might recreate the problem too.

# sudo ./xfs_metadump.sh -g /dev/md5p1 - | pbzip2 >
/home/tange/public_html/tmp/metadump.bz2
xfs_metadump: cannot init perag data (117)
Copying log

http://dna.ku.dk/~tange/tmp/metadump.bz2

Please consider providing an example in the man page for xfs_metadump e.g:

  xfs_metadump.sh -g /dev/sda2 meta.dump


/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
