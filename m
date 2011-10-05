Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p95Db4JG117760 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 08:37:04 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D306916B479B
	for <xfs@oss.sgi.com>; Wed,  5 Oct 2011 06:43:44 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id aETX0DDK16LtM5IG
	for <xfs@oss.sgi.com>; Wed, 05 Oct 2011 06:43:44 -0700 (PDT)
Received: by bkbzt12 with SMTP id zt12so2427231bkb.26
	for <xfs@oss.sgi.com>; Wed, 05 Oct 2011 06:37:01 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] xfstest: fsstress should kill children tasks before
	exit
In-Reply-To: <1317820838.2226.11.camel@doink>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
	<1317820838.2226.11.camel@doink>
Date: Wed, 05 Oct 2011 17:41:13 +0400
Message-ID: <87zkhf369y.fsf@dmbot.sw.ru>
MIME-Version: 1.0
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
To: aelder@sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, 5 Oct 2011 08:20:38 -0500, Alex Elder <aelder@sgi.com> wrote:
> On Sun, 2011-09-18 at 18:54 +0400, Dmitry Monakhov wrote:
> > It is very hard to predict runtime for fsstress. In many cases it
> > is useful to give test to run a reasonable time, and then kill it.
> > But currently there is no reliable way to kill test without leaving
> > running children.
> > This patch add sanity cleanup logic which looks follow:
> >  - On sigterm received by parent, it resend signal to it's children
> >  - Wait for each child to terminates
> >  - EXTRA_SANITY: Even if parent was killed by other signal, children
> >    will be terminated with SIGKILL to preven staled children.
> > 
> > So now one can simply run fsstress like this:
> > ./fsstress -p 1000 -n999999999 -d $TEST_DIR &
> > PID=$!
> > sleep 300
> > kill $PID
> > wait $PID
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> I think this is an interesting change and it looks
> OK to me.  I agree with Christoph's suggestion (on
> the second patch in this series) that it would be
> nice to have at least one of the tests make use of
> it, if nothing else just to document that it's a
> reasonable thing to do.
> 
> But even without that I think this is both useful
> and harmless.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
Ok i'll resend patch shortly, Actually test_case was explained inside
description. So far i've able to caught 3 different minor
fs-corruptions, one BUG_ON on ext4. And when i've run this test
on host with 24-cores it deadlock inside dcache core. 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
