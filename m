Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2FHeA7E159513 for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 12:40:11 -0500
Received: from www.open-std.org (vps-93-90-116-65.vpsforce.eu [93.90.116.65])
	by cuda.sgi.com with ESMTP id B6IPjsYf8ZomCKRm for
	<xfs@oss.sgi.com>; Thu, 15 Mar 2012 10:40:09 -0700 (PDT)
Date: Thu, 15 Mar 2012 18:40:08 +0100
From: keld@keldix.com
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Message-ID: <20120315174008.GB30531@www5.open-std.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<20120315152548.GA25194@www5.open-std.org>
	<CAA8mOyDquGX0kEbQSpo=S0EYdNvXNBQ6ZLnb5Sc7uvCPYB+xqA@mail.gmail.com>
	<20120315171548.GA30531@www5.open-std.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120315171548.GA30531@www5.open-std.org>
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
To: Jessie Evangelista <jessie.evangelista@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

On Thu, Mar 15, 2012 at 06:15:49PM +0100, keld@keldix.com wrote:
> On Fri, Mar 16, 2012 at 12:52:19AM +0800, Jessie Evangelista wrote:
> > Hi keld,
> > 
> > On Thu, Mar 15, 2012 at 11:25 PM,  <keld@keldix.com> wrote:
> > > On Thu, Mar 15, 2012 at 02:07:25PM +0000, Peter Grandi wrote:
> > >> >>> I want to create a raid10,n2 using 3 1TB SATA drives.
> > >> >>> I want to create an xfs filesystem on top of it. The
> > >> >>> filesystem will be used as NFS/Samba storage.
> > >>
> > >> Consider also an 'o2' layout (it is probably the same thing for a
> > >> 3 drive RAID10) or even a RAID5, as 3 drives and this usage seems
> > >> one of the few cases where RAID5 may be plausible.
> > >
> > > Well, for a file server like NFS/Samba, you could also consider raid10,f2.
> > > I would think you could get about double the read performance compared to n2 and o2
> > > layouts, and also for individual read transfers on a running system
> > > you would get somthing like double the read performance.
> > > Write performance could be somewhat slower (0 to 10 %) bot as users
> > > are not waiting for writes to complete, they will probably not notice.
> > 
> > I also plan to try raid10f2. Did you do your own benchmarks or are you
> > quoting someone elses?
> 
> Both, look at our wiki: https://raid.wiki.kernel.org/articles/p/e/r/Performance.html

I think it would be interesting to include your figures on the wiki page, if
you publish them here on the list. 

Maybe we should rearrange the wiki page a little. I am not so happy about the 
data reported in the section "New benchmarks from 2011" as it only illustrates
what is happening with a 100 % used CPU. I would like to move it to a separate page.
Also the really old data in section "Old performance benchmark" should be moved to
a separate page, IMHO. The text on the wiki page should be gaving info of
general interest for systems running today (still IMHO). Comments?

Best regards
keld

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
