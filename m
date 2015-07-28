Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D48447F7D
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 01:33:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A4F38304043
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2015 23:33:41 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [5.9.56.24]) by cuda.sgi.com
	with ESMTP id GVHVJo8wUos2hWzh (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Jul 2015 23:33:35 -0700 (PDT)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.84)
	(envelope-from <schmorp@schmorp.de>) id 1ZJySD-0001Ul-NB
	for xfs@oss.sgi.com; Tue, 28 Jul 2015 06:33:33 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.84)
	(envelope-from <schmorp@schmorp.de>) id 1ZJySD-0002Ze-Ib
	for xfs@oss.sgi.com; Tue, 28 Jul 2015 06:33:33 +0000
Received: from root by cerebro.laendle with local (Exim 4.84)
	(envelope-from <root@schmorp.de>) id 1ZJySD-0000ez-I9
	for xfs@oss.sgi.com; Tue, 28 Jul 2015 08:33:33 +0200
Date: Tue, 28 Jul 2015 08:33:33 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: FYI: questionable xfsdump code
Message-ID: <20150728063246.GA2510@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi!

While causally browsing xfsdump code,I found this, in
common/getdents.c:getdents_wrap (in xfsdump

        off64_t last_offset = -1;

        ...

        while ((char *)kdp < kbuf + retval) {
                ...

                if ((sizeof(dp->d_ino) != sizeof(kdp->d_ino))
                    || (sizeof(dp->d_off) != sizeof(kdp->d_off))) {
                        /* Overflow.  If there was at least one entry
                           before this one, return them without error,
                           otherwise signal overflow.  */
                        if (last_offset != -1) {
                                lseek64(fd, last_offset, SEEK_SET);
                                return (char *)dp - buf;
                        }
                        errno = EOVERFLOW;
                        return -1;
                }

                last_offset = d_off;

                ...
        }

While not necessarily a bug, this comment is very confused - there is no
way to reach the code inside the if with last_offset != -1, as the if
condition is a compiletime constant.

This might be harmless dead code from some refactorisation gone wrong,
or indicative of some bug due to some logic error. In any case, I just
wanted to bring it to your attention.

And as a side note, memcpy would be more efficient here, especially as it
is called very often, (and especially so on irix :-):

                memmove(dp->d_name, kdp->d_name,
                        old_reclen - offsetof(struct kernel_dirent64, d_name));

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
