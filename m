Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 450387FDF
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 14:27:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3296D3040D5
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 12:27:53 -0700 (PDT)
Received: from mail-ve0-f175.google.com (mail-ve0-f175.google.com
	[209.85.128.175]) by cuda.sgi.com with ESMTP id
	DOO4tFjkBxMkyhvN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 12:27:52 -0700 (PDT)
Received: by mail-ve0-f175.google.com with SMTP id oy10so673786veb.20
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 12:27:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALCETrXotDRKV8FtLn3g_9g_yOVceHzKpwXMAH+w7tBZ1P2F7A@mail.gmail.com>
References: <cover.1376679411.git.luto@amacapital.net>
	<ec267e95fd21891986373c7af1c72b4c8b507332.1376679411.git.luto@amacapital.net>
	<20130820023615.GE6023@dastard>
	<CALCETrV-Toj-NGpmWnmoUbCwrMUXOSbjQdYsSVuTiH+2dEgPTQ@mail.gmail.com>
	<20130820040814.GH6023@dastard>
	<CALCETrWreWBwKdKS2w=fS+MwdaZv1eEsKjYo=P9eeXe7fZS6Jw@mail.gmail.com>
	<20130820160057.GC2862@quack.suse.cz>
	<CALCETrXotDRKV8FtLn3g_9g_yOVceHzKpwXMAH+w7tBZ1P2F7A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Aug 2013 12:27:31 -0700
Message-ID: <CALCETrXqZ3Fgp9JHRJZCRfW-+qq2T_xw7Y_xyn2i=xK5+pdZoQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm: Notify filesystems when it's time to apply a
	deferred cmtime update
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

On Tue, Aug 20, 2013 at 9:42 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Aug 20, 2013 at 9:00 AM, Jan Kara <jack@suse.cz> wrote:
>> On Mon 19-08-13 21:14:44, Andy Lutomirski wrote:
>>> >> I could require ->writepages *and* ->flush_cmtime to handle the time
>>> >> update, but that would complicate non-transactional filesystems.
>>> >> Those filesystems should just flush cmtime at the end of writepages.
>>> >
>>> > do_writepages() is the wrong place to do such updates - we can get
>>> > writeback directly through .writepage, so the time updates need to
>>> > be in .writepage. That first .writepage call will clear the bit on
>>> > the mapping, so it's only done on the first call to .writepage on
>>> > the given mapping.
>>>
>>> Last time I checked, all the paths that actually needed the timestamp
>>> update went through .writepages.  I'll double-check.
>>   kswapd can call just .writepage to do the writeout so timestamp update
>> should be handled there as well. Otherwise all pages in a mapping can be
>> cleaned without timestamp being updated.
>
> OK, I'll fix that.

This is a bit ugly.  mpage_writepages and generic_writepages both call
->writepage.  If writepage starts checking cmtime, then writepages
will do multiple timestamp updates on filesystems that use this code.

I can modify vmscan and migrate to flush cmtime -- they seem to be the
only callers of ->writepage that aren't themselves called from
->writepages.

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
