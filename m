Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAD20ED6010883 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 20:00:14 -0600
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	JKXcSlVSqSZNJmDi (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 18:02:16 -0800 (PST)
Received: by mail-lb0-f181.google.com with SMTP id ge1so1326396lbb.26
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 18:02:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121113015318.GD25039@dastard>
References: <CACnwZYd2kPaK1urLYc8BBuuqD7_Oo1oF+KvqWYj7DAEGy6grHQ@mail.gmail.com>
	<20121113015318.GD25039@dastard>
Date: Tue, 13 Nov 2012 00:02:14 -0200
Message-ID: <CACnwZYeutkdb+=yYx8XcXHSDhaP6QBjgn1BEnGAMYDO7biAtFw@mail.gmail.com>
Subject: Re: xfs: Remove boolean_t typedef completely.
From: Thiago Farina <tfransosi@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, linux list <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Nov 12, 2012 at 11:53 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 12, 2012 at 10:36:47PM -0200, Thiago Farina wrote:
>> On Mon, Nov 12, 2012 at 10:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Nov 12, 2012 at 09:36:17PM -0200, Thiago Farina wrote:
>> >> Hi,
>> >>
>> >> Please, take a look.
>> >>
>> >> Patch attached.
>> >
>> > It's a good start for a cleanup, but there's no point in removing
>> > the boolean_t from one file and then not removing it from the rest
>> > of the XFS code.  It's only used in a handful of places, so just
>> > remove it completely.
>> >
>> Done.
>>
>> Please, take another look.
>>
>> > Also, can you please place patches in line rather than attaching
>> > them. Attaching them means they cannot be quoted in reply. See
>> > Documentation/SubmittingPatches and Documentation/email-clients.txt
>> > for guidelines.
>> >
>> Sorry, patch attached.
>
> It's still attached as a base64 encoded attachment, not as inline
> text....
>
Yep, sorry about that. Is just a text file from $(git format-patch master);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
