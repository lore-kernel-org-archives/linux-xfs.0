Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1I0YxRM120731 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 18:35:00 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id O5VkpmLnROIHONHA
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Feb 2012 16:34:58 -0800 (PST)
Received: by lahd3 with SMTP id d3so4583053lah.26
	for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 16:34:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGdb-8eMcBghwznGbGQha01paF1L+MdB3QsxHCuCh6ZOW=wsag@mail.gmail.com>
References: <CAGdb-8fC4-3swyyfP3xO=camgzDjR5GYV3qoaB1w+xAfiNeYPw@mail.gmail.com>
	<4F3EBDA6.7070108@sgi.com>
	<CAGdb-8eMcBghwznGbGQha01paF1L+MdB3QsxHCuCh6ZOW=wsag@mail.gmail.com>
Date: Sat, 18 Feb 2012 08:34:56 +0800
Message-ID: <CAGdb-8fXE0yVn15WS71z3QR-UShe46DDTd_K1sEJXKMnD2nkkA@mail.gmail.com>
Subject: Re: xfsrestore will create orphanage directory when use -t
From: Tommy Wu <wu.tommy@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs <xfs@oss.sgi.com>

2012/2/18 Tommy Wu <wu.tommy@gmail.com>:
> 2012/2/18 Bill Kendall <wkendall@sgi.com>:
>> On 02/14/2012 11:21 AM, Tommy Wu wrote:
>>>
>>> from the xfsdump man page:
>>> xfsrestore also generates a directory named orphanage in the dest
>>> directory. xfsrestore removes this directory after completing a simple
>>> restore. However, if orphanage is not empty, it is not removed. This
>>> can happen if files present on the dump media are not referenced by
>>> any of the restored directories. The orphanage has an entry for each
>>> such file. The entry name is the file's original inode number, a ".",
>>> and the file's generation count modulo 4096 (only the lower 12 bits of
>>> the generation count are used).
>>>
>>> and the -t option from xfsdump man page:
>>> Displays the contents of the dump, but does not create or modify any
>>> files or directories. It may be desirable to set the verbosity level
>>> to silent when using this option.
>>>
>>> But when we use -t option with xfsrestore, it still create orphanage
>>> directory in current directory (because no dest directory assign).
>>> and if it's not empty, it is not removed.
>>>
>>> This is a bug or it's a feature?
>>
>>
>> I can see code where this would happen, except that it would appear
>> to require both -r and -t to be used, and xfsrestore doesn't allow
>> that.
>>
>> If you send the command line you used I can take another look.
>>
>> Bill
>
> here is the command I used for -t:
> cat var.xfsdump.gz | gzip -dqv | xfsrestore -v silent -p 300 -J -t - |
> grep "^xfsrestore:"
>
> I also test it with only -t option, it also create orphanage folder
> for such dump file (not all dump file has this issue)
> cat var.xfsdump.gz | gzip -dqv | xfsrestore -t - | grep "^xfsrestore:"
>
>
> --
>
> Tommy Wu

I use xfsdump 3.0.6 plus following 2 patch:
[PATCH] xfsdump: allow system() to obtain exit status
[PATCH] xfsdump: handle files with no extent headers

-- 

Tommy Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
