Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B90D7F4E
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 17:56:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 358DAAC002
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 15:56:19 -0800 (PST)
Received: from mail-ob0-f179.google.com (mail-ob0-f179.google.com
	[209.85.214.179]) by cuda.sgi.com with ESMTP id
	50rgauXHW7cs8Snl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 15:56:18 -0800 (PST)
Received: by mail-ob0-f179.google.com with SMTP id m8so9948870obr.38
	for <xfs@oss.sgi.com>; Mon, 03 Nov 2014 15:56:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141103223407.GA14732@bfoster.bfoster>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
	<1415031146-9107-6-git-send-email-bfoster@redhat.com>
	<CA+o=1OWm3XWUgNXR1_CravnEBL8fD8dwyMvY4CN9rbAsw0Q4Sw@mail.gmail.com>
	<20141103223407.GA14732@bfoster.bfoster>
Date: Tue, 4 Nov 2014 00:56:17 +0100
Message-ID: <CA+o=1OWy=VSo3XYMd9LuxiqzRp=p+5iJ909uoJzgKYdOOyVcvg@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] xfs: create macros/helpers for dealing with
	sparse inode chunks
From: Fanael Linithien <fanael4@gmail.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

2014-11-03 23:34 GMT+01:00 Brian Foster <bfoster@redhat.com>:
> On Mon, Nov 03, 2014 at 11:12:12PM +0100, Fanael Linithien wrote:
>> 2014-11-03 17:12 GMT+01:00 Brian Foster <bfoster@redhat.com>:
>> >
>> > +static inline bool xfs_inobt_issparse(uint16_t holemask)
>> > +{
>> > +       return holemask == 0 ? false : true;
>> > +}
>>
>> Surely that should be "return holemask != 0;"?
>>
>
> ir_holemask bits are set for holes in the inode chunk and unset for
> allocated regions. This means that ir_holemask == 0 for a normal,
> fully-allocated chunk and != 0 otherwise (some bits are set to indicate
> the chunk has a hole). Check out the commit log for patch 4 for
> reasoning.

Oh, I don't comment on the logic, as I don't really know much about
XFS code. It's purely a stylistic suggestion: "holemask == 0 ? false :
true" looks entirely equivalent to "holemask != 0".

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
