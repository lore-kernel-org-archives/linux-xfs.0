Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAD2U7jU012709 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 20:30:07 -0600
Date: Mon, 12 Nov 2012 20:32:07 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfs: Remove boolean_t typedef completely.
Message-ID: <20121113023207.GZ9783@sgi.com>
References: <CACnwZYd2kPaK1urLYc8BBuuqD7_Oo1oF+KvqWYj7DAEGy6grHQ@mail.gmail.com>
	<20121113015318.GD25039@dastard>
	<CACnwZYeutkdb+=yYx8XcXHSDhaP6QBjgn1BEnGAMYDO7biAtFw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACnwZYeutkdb+=yYx8XcXHSDhaP6QBjgn1BEnGAMYDO7biAtFw@mail.gmail.com>
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
To: Thiago Farina <tfransosi@gmail.com>
Cc: Alex Elder <elder@kernel.org>, linux list <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi Thiago,

On Tue, Nov 13, 2012 at 12:02:14AM -0200, Thiago Farina wrote:
> On Mon, Nov 12, 2012 at 11:53 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Nov 12, 2012 at 10:36:47PM -0200, Thiago Farina wrote:
> >> On Mon, Nov 12, 2012 at 10:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Mon, Nov 12, 2012 at 09:36:17PM -0200, Thiago Farina wrote:
> >> >> Hi,
> >> >>
> >> >> Please, take a look.
> >> >>
> >> >> Patch attached.
> >> >
> >> > It's a good start for a cleanup, but there's no point in removing
> >> > the boolean_t from one file and then not removing it from the rest
> >> > of the XFS code.  It's only used in a handful of places, so just
> >> > remove it completely.
> >> >
> >> Done.
> >>
> >> Please, take another look.
> >>
> >> > Also, can you please place patches in line rather than attaching
> >> > them. Attaching them means they cannot be quoted in reply. See
> >> > Documentation/SubmittingPatches and Documentation/email-clients.txt
> >> > for guidelines.
> >> >
> >> Sorry, patch attached.
> >
> > It's still attached as a base64 encoded attachment, not as inline
> > text....
> >
> Yep, sorry about that. Is just a text file from $(git format-patch master);

If you don't mind another try... it would be helpful if you could resend the
patch inline.  It helps to facilitate a discussion of the patch along with your
text should it be necessary.

You're only touching xfs, so you can drop linux-kernel if you want.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
