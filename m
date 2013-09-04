Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5967D7F53
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 12:33:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C4F68F8040
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 10:33:45 -0700 (PDT)
Received: from mail-vc0-f170.google.com (mail-vc0-f170.google.com
	[209.85.220.170]) by cuda.sgi.com with ESMTP id
	v1a9Q8o6IiqBEpCx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 10:33:43 -0700 (PDT)
Received: by mail-vc0-f170.google.com with SMTP id kw10so399286vcb.29
	for <xfs@oss.sgi.com>; Wed, 04 Sep 2013 10:33:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130904150854.GF3996@quack.suse.cz>
References: <cover.1377193658.git.luto@amacapital.net>
	<20130904150854.GF3996@quack.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Sep 2013 10:33:22 -0700
Message-ID: <CALCETrVayD1P2a8ShjZ2e4HYGwL_yE8FM7GnrWaL9MgXYMGvHg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped writes
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
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>

On Wed, Sep 4, 2013 at 8:08 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 22-08-13 17:03:16, Andy Lutomirski wrote:
>> Writes via mmap currently update mtime and ctime in ->page_mkwrite.
>> This hurts both throughput and latency.  In workloads that dirty a
>> large number of mmapped pages, ->page_mkwrite can be hot and
>> file_update_time is slow and scales poorly.  Updating timestamps can
>> also sleep, which hurts latency for real-time workloads.
>   It would help to make your case if you posted the latency comparison
> before & after the patchset in this introductory email. We can then see
> how significant is the reduction of latency...

Will do, although the data from my workload will be a little strange.

I was hoping that Dave Hansen would re-run his benchmark with these
patches applied.  I tried to run it, but it wasn't obvious what the
numbers that spewed out meant.

--Andy

>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR



-- 
Andy Lutomirski
AMA Capital Management, LLC

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
