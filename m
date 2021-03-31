Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE274C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A8F4619CD
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhCaBQu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232956AbhCaBQa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:16:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F591619D9
        for <linux-xfs@vger.kernel.org>; Wed, 31 Mar 2021 01:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617153390;
        bh=vNh9PaIgNNh25551ENzqSMHgWGi7R4YrLW1Zwrmmj/E=;
        h=From:To:Subject:Date:From;
        b=dfa7mEZZj9zUJFYSykfKwxI31DT/fvNx3TpzCrQA7N31/qoevTYrOSmK/uZrx/f7L
         86w6rrXKkRnKXzv+/sIwOKUuKq81Kv9q84UszHVyr7/KcWzEwG0TR4q3wIlaXDnPzx
         iveHEOBbBcsfHCySuvy5SmBpA0p0FJ6iMPY5YA6bAyZph/8ncrsfsX2hOryKWa3n6L
         8kq2k8X8KFB04ugNAZKIUl0A36DVEJEJCKKsd/QjkC73fVr9bKMh72K26B0GaMoJf8
         14sky7ZAw6OhK40KYm5uyYa4YbvXTGupxekFXvr5P50GOpDYPUPVTC7hYOHVu0dfgv
         PyxLoE7+zdHTA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 212495] New: xfs: system crash caused by null bp->b_pages
Date:   Wed, 31 Mar 2021 01:16:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zp_8483@163.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-212495-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212495

            Bug ID: 212495
           Summary: xfs: system crash caused by null bp->b_pages
           Product: File System
           Version: 2.5
    Kernel Version: 3.10
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zp_8483@163.com
        Regression: No

We have encountered the following problems several times:
    1=E3=80=81Hardware problem causes block device loss.
    2=E3=80=81Continue to send IO requests to the block device.
    3=E3=80=81The system possibly crash after a few hours.




15205901.386974] RIP: 0010:xfs_buf_offset+0x32/0x60 [xfs]
[15205901.388044] RSP: 0018:ffffb28ba9b3bc68 EFLAGS: 00010246
[15205901.389021] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
000000000000000b
[15205901.390016] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffff88627bebf000
[15205901.391075] RBP: ffffb28ba9b3bc98 R08: ffff88627bebf000 R09:
00000001802a000d
[15205901.392031] R10: ffff88521f3a0240 R11: ffff88627bebf000 R12:
ffff88521041e000
[15205901.392950] R13: 0000000000000020 R14: ffff88627bebf000 R15:
0000000000000000
[15205901.393858] FS: 0000000000000000(0000) GS:ffff88521f380000(0000)
knlGS:0000000000000000
[15205901.394774] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15205901.395756] CR2: 0000000000000000 CR3: 000000099bc09001 CR4:
00000000007606e0
[15205901.396904] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[15205901.397869] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[15205901.398836] PKRU: 55555554
[15205901.400111] Call Trace:
[15205901.401058] ? xfs_inode_buf_verify+0x8e/0xf0 [xfs]
[15205901.402069] ? xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
[15205901.403060] xfs_inode_buf_write_verify+0x10/0x20 [xfs]
[15205901.404017] _xfs_buf_ioapply+0x88/0x410 [xfs]
[15205901.404990] ? xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
[15205901.405929] xfs_buf_submit+0x63/0x200 [xfs]
[15205901.406801] xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
[15205901.407675] ? xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
[15205901.408540] ? xfs_inode_item_push+0xb7/0x190 [xfs]
[15205901.409395] xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
[15205901.410249] xfsaild+0x29a/0x780 [xfs]
[15205901.411121] kthread+0x109/0x140
[15205901.411981] ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[15205901.412785] ? kthread_park+0x60/0x60
[15205901.413578] ret_from_fork+0x2a/0x40

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
From vmcore, we found that b_pages=3DNULL but b_page_count=3D16.

crash> struct xfs_buf 0xffff9005c51fb300
struct xfs_buf {
  b_rhash_head =3D {
    next =3D 0x0
  },
  b_bn =3D 481790464,
  b_length =3D 128,
  b_hold =3D {
    counter =3D 2
  },
  b_lru_ref =3D {
    counter =3D 0
  },
  b_flags =3D 1048626,
  b_sema =3D {
    lock =3D {
      raw_lock =3D {
        val =3D {
          counter =3D 0
        }
      }
    },
    count =3D 0,
    wait_list =3D {
      next =3D 0xffff9005c51fb328,
      prev =3D 0xffff9005c51fb328
    }
  },
  b_lru =3D {
    next =3D 0xffff9005c51fb338,
    prev =3D 0xffff9005c51fb338
  },
  b_lock =3D {
    {
      rlock =3D {
        raw_lock =3D {
          val =3D {
            counter =3D 0
          }
        }
      }
    }
  },
  b_state =3D 3,
  b_io_error =3D 0,
  b_waiters =3D {
    lock =3D {
      {
        rlock =3D {
          raw_lock =3D {
            val =3D {
              counter =3D 0
            }
          }
        }
      }
    },
    task_list =3D {
      next =3D 0xffff9005c51fb360,
      prev =3D 0xffff9005c51fb360
    }
  },
  b_list =3D {
    next =3D 0xffff9005c51fb370,
    prev =3D 0xffff9005c51fb370
  },
  b_pag =3D 0xffff9005de557400,
  b_target =3D 0xffff9005ddff0d80,
  b_addr =3D 0x0,
  b_ioend_work =3D {
    data =3D {
      counter =3D 1920
    },
    entry =3D {
      next =3D 0xffff9005c51fb3a0,
      prev =3D 0xffff9005c51fb3a0
    },
    func =3D 0xffffffffc081ce80 <xfs_buf_ioend_work>
  },
  b_ioend_wq =3D 0xffff9035d433bc00,
  b_iodone =3D 0xffffffffc0843220 <xfs_buf_iodone_callbacks>,
  b_iowait =3D {
    done =3D 0,
    wait =3D {
      lock =3D {
        {
          rlock =3D {
            raw_lock =3D {
              val =3D {
                counter =3D 0
              }
            }
          }
        }
      },
      task_list =3D {
        next =3D 0xffff9005c51fb3d8,
        prev =3D 0xffff9005c51fb3d8
      }
    }
  },
  b_fspriv =3D 0xffff9005c5b9c690,
  b_transp =3D 0x0,
  b_pages =3D 0x0,
  b_page_array =3D {0x0, 0x0},
  b_maps =3D 0xffff9005c51fb418,
  __b_map =3D {
    bm_bn =3D 481790464,
    bm_len =3D 128
  },
  b_map_count =3D 1,
  b_io_length =3D 128,
  b_pin_count =3D {
    counter =3D 0
  },
  b_io_remaining =3D {
    counter =3D 1
  },
  b_page_count =3D 16,=C6=92b
  b_offset =3D 0,
  b_error =3D 0,
  b_retries =3D 0,
  b_first_retry_time =3D 0,
  b_last_error =3D -5,
  b_ops =3D 0xffffffffc085cf00 <xfs_inode_buf_ops>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
file: xfs_log.c function: xlog_sync, it seems current code not handle alloc=
ate
memory fail.

if (split) {
                bp =3D iclog->ic_log->l_xbuf;
                XFS_BUF_SET_ADDR(bp, 0); /* logical 0 */
                xfs_buf_associate_memory(bp,
                                (char *)&iclog->ic_header + count, split);
                bp->b_fspriv =3D iclog;
                bp->b_flags &=3D ~XBF_FLUSH;
                bp->b_flags |=3D (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_=
FUA);

                ASSERT(XFS_BUF_ADDR(bp) <=3D log->l_logBBsize-1);
                ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <=3D log->l_logBBsiz=
e);

                /* account for internal log which doesn't start at block #0=
 */
                XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
                error =3D xlog_bdstrat(bp);
                if (error) {
                        xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
                        return error;
                }
        }

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
