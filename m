Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 673A07F61
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:41:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 55C2F8F8033
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:41:47 -0700 (PDT)
Received: from mail-da0-f51.google.com (mail-da0-f51.google.com
	[209.85.210.51]) by cuda.sgi.com with ESMTP id IeBYlqC2YdCZWE37
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:41:46 -0700 (PDT)
Received: by mail-da0-f51.google.com with SMTP id z17so1210348dal.24
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:41:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513A4AEC.4010202@sandeen.net>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<512FA67D.2090708@sandeen.net>
	<CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
	<5130DB54.9030503@sandeen.net>
	<CANU9nTkekrw2mdptFdK2RVUFXD=evt0sTZhB9VL+PKY8DTj11A@mail.gmail.com>
	<5134BBA4.3060305@sandeen.net>
	<CANU9nTntXh5spRYc80OhsBqgLnZcJGA2qBeVVQaywthD1RMu4w@mail.gmail.com>
	<513A4AEC.4010202@sandeen.net>
From: Ole Tange <tange@binf.ku.dk>
Date: Tue, 12 Mar 2013 11:41:25 +0100
Message-ID: <CANU9nTnLe76Jm9nYPhoLUZoESfshGyE-RBJ-gkdZZ2Nx3wiC0w@mail.gmail.com>
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

On Fri, Mar 8, 2013 at 9:32 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/8/13 4:21 AM, Ole Tange wrote:
>> On Mon, Mar 4, 2013 at 4:20 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>>> 2) so you could run a "real" non-"n" xfs_repair on a metadata image as a more realistic dry run
:
>> I get
>> filenames like:
>>
>> /mnt/disk/??5?z+hEOgl/?7?Psr1?aIH<?ip:??/>S??+??z=ozK/8_0/???d)
>> 5JCG?eiBd?EVsNF'A?v?m?f;Fi6v)d>/?M%?A??J?)B<soGlc??QuY!e-<,6G?
>> X[Df?Wm^[?f 4|
>
> By default, xfs_metadump scrambles filenames, so nothing to worry
> about (it's for privacy reasons).  If you use the "-o" option it'll keep
> it in the clear.

Ahh. To me that does not conform to Principle of Least Astonishment -
especially since some of the filenames were not obfuscated.

I would have been less surprised if the files were named:

    Use_-o_for_real_file_names_XXXXXXXX
    Use_-o_for_real_dir_names_XXXXXXXX

where XXXXXXXX is just a unique number.


/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
